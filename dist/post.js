const { cwd } = require('node:process')
const { getInput, setFailed, setOutput } = require('@actions/core')
const cmd = require('./cmd')

const job = async () => {
  try {
    const name = getInput('name')
    console.log('jajal-post:', name)

    const branch = await cmd('git branch -a')
    console.log('jajal-post-branch:', branch)

    const ls = await cmd('ls -laihs')
    console.log('jajal-post-ls:', ls)

    console.log('jajal-post-cwd:', cwd())

    setOutput('kucrit-post', name)
  } catch (err) {
    setFailed('rusak dari post')
  }
}

job()
