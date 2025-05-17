import { cwd } from 'node:process'

import { getInput, setFailed, setOutput } from '@actions/core'

import cmd from './cmd'

const job = async (): Promise<void> => {
  const name = getInput('name')
  console.log('jajal-post:', name)

  const ls = await cmd('ls -laihs')
  console.log('jajal-post-ls:', ls)

  console.log('jajal-post-cwd:', cwd())

  setOutput('kucrit-post', name)
}

job()
  .then((result) => {
    setOutput('kucrit-post', result)
  })
  .catch((error) => {
    setFailed(error as Error)
  })
