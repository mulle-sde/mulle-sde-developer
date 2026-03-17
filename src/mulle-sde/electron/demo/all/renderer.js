// Renderer process code
console.log('Renderer process loaded');

// Example: Call IPC command
async function testCommand() {
  const uname = await window.api.runCommand('uname');
  const hostname = await window.api.runCommand('hostname');
  const username = await window.api.runCommand('username');
  
  console.log('System info:', { uname, hostname, username });
}

// Uncomment to test on load:
// testCommand();
