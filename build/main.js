'use strict';

var node_process = require('node:process');
var core = require('@actions/core');
var node_child_process = require('node:child_process');

const nia = async (cli) => {
  const promise = new Promise((resolve, reject) => {
    try {
      node_child_process.exec(cli, (error, stdout, stderr) => {
        if (error) {
          reject(error);
          return;
        }
        if (stderr) {
          reject(stderr);
          return;
        }
        resolve(stdout);
      });
    } catch (error) {
      reject(error);
    }
  });
  return await promise;
};

const job = async () => {
  const name = core.getInput("name");
  console.log("jajal-main:", name);
  const ls = await nia("ls -laihs");
  console.log("jajal-main-ls:", ls);
  console.log("jajal-main-cwd:", node_process.cwd());
  const ghVersion = await nia("gh --version");
  console.log("jajal-main-gh-version:", ghVersion);
  const gitVersion = await nia("git --version");
  console.log("jajal-main-git-version:", gitVersion);
  core.setOutput("kucrit-main", name);
};
job().then((result) => {
  core.setOutput("kucrit-main", result);
}).catch((error) => {
  console.log(error);
  console.error(error);
  core.setFailed(error);
});
