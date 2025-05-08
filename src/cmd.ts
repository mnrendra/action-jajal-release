import { exec } from 'node:child_process'

const cmd = async (
  cli: string
): Promise<string> => {
  const promise = new Promise<string>((resolve, reject) => {
    try {
      exec(cli, (error, stdout, stderr) => {
        if (error !== null) {
          reject(error.message)
          return
        }

        if (typeof stderr === 'string') {
          reject(stderr)
          return
        }

        resolve(stdout)
      })
    } catch (err) {
      reject(err)
    }
  })

  return await promise
}

export default cmd
