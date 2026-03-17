#!/usr/bin/env node
const { spawn } = require('child_process');
const path = require('path');

const electronPath = require('electron');
const appPath = path.join(__dirname, 'main.js');

const child = spawn(electronPath, [appPath, '--no-sandbox'], {
  stdio: 'inherit',
  windowsHide: false
});

child.on('close', (code) => {
  process.exit(code);
});
