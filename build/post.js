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
  console.log("jajal-post:", name);
  const ls = await nia("ls -laihs");
  console.log("jajal-post-ls:", ls);
  console.log("jajal-post-cwd:", node_process.cwd());
  core.setOutput("kucrit-post", name);
};
job().then((result) => {
  core.setOutput("kucrit-post", result);
}).catch((error) => {
  core.setFailed(error);
});
