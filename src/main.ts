import { cwd } from 'node:process'

import { getInput, setFailed, setOutput } from '@actions/core'

import cmd from './cmd'

const job = async (): Promise<void> => {
  const name = getInput('name')
  console.log('jajal-main:', name)

  const ls = await cmd('ls -laihs')
  console.log('jajal-main-ls:', ls)

  console.log('jajal-main-cwd:', cwd())

  setOutput('kucrit-main', name)
}

job()
  .then((result) => {
    setOutput('kucrit-main', result)
  })
  .catch((error) => {
    setFailed(error as Error)
  })
