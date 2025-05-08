const { getInput, setFailed, setOutput } = require('@actions/core')
const cmd = require('./cmd')

try {
  const name = getInput('name')
  console.log('jajal-pre:', name)

  const branch = cmd('git branch -a')
  console.log('jajal-pre-branch:', branch)

  const ls = cmd('ls -laihs')
  console.log('jajal-pre-ls:', ls)

  console.log('jajal-pre-cwd:', process.cwd())

  setOutput('kucrit-pre', name)
} catch (err) {
  setFailed('rusak dari pre')
}
