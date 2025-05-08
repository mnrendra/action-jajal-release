const { cwd } = require('node:process')
const { getInput, setFailed, setOutput } = require('@actions/core')
const cmd = require('./cmd')

const job = async () => {
  try {
    const name = getInput('name')
    console.log('jajal-pre:', name)

    // const branch = await cmd('git branch -a')
    // console.log('jajal-pre-branch:', branch)

    const ls = await cmd('ls -laihs')
    console.log('jajal-pre-ls:', ls)

    console.log('jajal-pre-cwd:', cwd())

    setOutput('kucrit-pre', name)
  } catch (err) {
    setFailed(err)
  }
}

job()
