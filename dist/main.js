const { cwd } = require('node:process')
const { getInput, setFailed, setOutput } = require('@actions/core')
const cmd = require('./cmd')

const job = async () => {
  try {
    const name = getInput('name')
    console.log('jajal-main:', name)

    // const branch = await cmd('git branch -a')
    // console.log('jajal-main-branch:', branch)

    const ls = await cmd('ls -laihs')
    console.log('jajal-main-ls:', ls)

    console.log('jajal-main-cwd:', cwd())

    setOutput('kucrit-main', name)
  } catch (err) {
    setFailed(err)
  }
}

job()
