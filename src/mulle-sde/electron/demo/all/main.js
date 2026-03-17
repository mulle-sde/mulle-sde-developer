const { app, BrowserWindow, Menu, shell, ipcMain } = require('electron');
const path = require('path');
const { execSync } = require('child_process');

// Intercept console output and forward to main process console
function setupLogging(webContents) {
  webContents.on('console-message', (event, level, message, line, sourceId) => {
    const levels = ['log', 'warn', 'error'];
    const method = levels[level] || 'log';
    console[method](`[Renderer] ${message}`);
  });
}

// IPC handler for running shell commands
ipcMain.handle('run-command', async (event, command) => {
  try {
    let cmd;
    switch (command) {
      case 'uname':
        cmd = 'uname';
        break;
      case 'hostname':
        cmd = 'hostname';
        break;
      case 'username':
        cmd = 'whoami';
        break;
      default:
        throw new Error(`Unknown command: ${command}`);
    }
    const result = execSync(cmd, {
      encoding: 'utf-8',
      cwd: process.cwd()
    });
    return result.trim();
  } catch (error) {
    console.error(`Failed to run ${command}:`, error);
    return null;
  }
});

function createMenu() {
  const template = [
    {
      label: 'Edit',
      submenu: [
        { role: 'undo' },
        { role: 'redo' },
        { type: 'separator' },
        { role: 'cut' },
        { role: 'copy' },
        { role: 'paste' },
        { role: 'selectAll' }
      ]
    },
    {
      label: 'View',
      submenu: [
        { role: 'reload' },
        { role: 'forceReload' },
        { role: 'toggleDevTools' },
        { type: 'separator' },
        { role: 'resetZoom' },
        { role: 'zoomIn' },
        { role: 'zoomOut' },
        { type: 'separator' },
        { role: 'togglefullscreen' }
      ]
    },
    {
      label: 'Help',
      submenu: [
        {
          label: 'About <|PROJECT_NAME|>',
          click: () => {
            const aboutWindow = new BrowserWindow({
              width: 400,
              height: 300,
              resizable: false,
              minimizable: false,
              maximizable: false,
              title: 'About <|PROJECT_NAME|>'
            });
            aboutWindow.setMenu(null);
            aboutWindow.loadURL(`data:text/html;charset=utf-8,
              <!DOCTYPE html>
              <html>
              <head>
                <style>
                  body { 
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    padding: 40px;
                    text-align: center;
                    background: #f5f5f5;
                  }
                  h1 { margin: 20px 0 10px 0; }
                  p { color: #666; }
                </style>
              </head>
              <body>
                <h1><|PROJECT_NAME|></h1>
                <p>Version 0.0.1</p>
                <p>© <|YEAR|> <|AUTHOR|></p>
              </body>
              </html>
            `);
          }
        }
      ]
    }
  ];

  // Add macOS-specific menu
  if (process.platform === 'darwin') {
    template.unshift({
      label: app.name,
      submenu: [
        { role: 'about' },
        { type: 'separator' },
        { role: 'services' },
        { type: 'separator' },
        { role: 'hide' },
        { role: 'hideOthers' },
        { role: 'unhide' },
        { type: 'separator' },
        { role: 'quit' }
      ]
    });
  }

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}

function createWindow() {
  const mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false
    }
  });

  setupLogging(mainWindow.webContents);
  mainWindow.loadFile('index.html');
}

app.whenReady().then(() => {
  createMenu();
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
