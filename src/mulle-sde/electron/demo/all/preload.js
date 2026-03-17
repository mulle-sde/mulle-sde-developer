const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('api', {
  // Run shell commands via IPC
  runCommand: (command) => ipcRenderer.invoke('run-command', command)
});
