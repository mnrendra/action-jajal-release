const { exec } = require('node:child_process')

const cmd = (cli) => {
  const promise = new Promise((resolve, reject) => {
    try {
      exec(cli, (error, stdout, stderr) => {
        if (error) {
          reject(error.message)
          return
        }
    
        if (stderr) {
          reject(stderr)
          return
        }
        
        resolve(stdout)
      })
    } catch (err) {
      reject(err)
    }
  })

  return promise
}

module.exports = cmd
