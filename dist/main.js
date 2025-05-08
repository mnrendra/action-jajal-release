const { getInput, setFailed, setOutput } = require('@actions/core')
const cmd = require('./cmd')

try {
  const name = getInput('name')
  console.log('jajal-main:', name)

  const branch = cmd('git branch -a')
  console.log('jajal-main-branch:', branch)

  const ls = cmd('ls -laihs')
  console.log('jajal-main-ls:', ls)

  console.log('jajal-main-cwd:', process.cwd())

  setOutput('kucrit-main', name)
} catch (err) {
  setFailed('rusak dari main')
}
