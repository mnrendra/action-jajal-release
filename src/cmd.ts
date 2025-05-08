import { exec } from 'node:child_process'

const nia = async (
  cli: string
): Promise<string> => {
  const promise = new Promise<string>((resolve, reject) => {
    try {
      exec(cli, (error, stdout, stderr) => {
        /* eslint-disable-next-line */
        if (error) {
          reject(error)
          return
        }

        /* eslint-disable-next-line */
        if (stderr) {
          reject(stderr)
          return
        }

        resolve(stdout)
      })
    } catch (error) {
      reject(error)
    }
  })

  return await promise
}

export default nia
