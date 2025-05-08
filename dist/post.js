const { getInput, setFailed, setOutput } = require('@actions/core')

try {
  const name = getInput('name')
  console.log('post:', name)
  setOutput('kucrit-post', name)
} catch (err) {
  setFailed('rusak dari post')
}
