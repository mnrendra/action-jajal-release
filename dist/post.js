const { getInput, setFailed, setOutput } = require('@actions/core')
const cmd = require('./cmd')

try {
  const name = getInput('name')
  console.log('jajal-post:', name)

  const branch = cmd('git branch -a')
  console.log('jajal-post-branch:', branch)

  const ls = cmd('ls -laihs')
  console.log('jajal-post-ls:', ls)

  console.log('jajal-post-cwd:', process.cwd())

  setOutput('kucrit-post', name)
} catch (err) {
  setFailed('rusak dari post')
}
