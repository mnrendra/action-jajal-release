const { getInput, setFailed, setOutput } = require('@actions/core')

try {
  const name = getInput('name')
  console.log('main:', name)
  setOutput('kucrit-main', name)
} catch (err) {
  setFailed('rusak dari main')
}
