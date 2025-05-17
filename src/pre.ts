import { cwd } from 'node:process'

import { getInput, setFailed, setOutput } from '@actions/core'

import cmd from './cmd'

const job = async (): Promise<void> => {
  const name = getInput('name')
  console.log('jajal-pre:', name)

  const ls = await cmd('ls -laihs')
  console.log('jajal-pre-ls:', ls)

  console.log('jajal-pre-cwd:', cwd())

  setOutput('kucrit-pre', name)
}

job()
  .then((result) => {
    setOutput('kucrit-pre', result)
  })
  .catch((error) => {
    setFailed(error as Error)
  })
