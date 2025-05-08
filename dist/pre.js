const { getInput, setFailed, setOutput } = require('@actions/core')

try {
  const name = getInput('name')
  console.log('pre:', name)
  setOutput('kucrit-pre', name)
} catch (err) {
  setFailed('rusak dari pre')
}
