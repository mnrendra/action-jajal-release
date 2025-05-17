import esbuild from 'rollup-plugin-esbuild'

export default [
  // Build pre source
  {
    external: (id) => !/^[./]/.test(id),
    input: 'src/pre.ts',
    output: {
      file: 'build/pre.js',
      format: 'cjs'
    },
    plugins: esbuild()
  },
  // Build main source
  {
    external: (id) => !/^[./]/.test(id),
    input: 'src/main.ts',
    output: {
      file: 'build/main.js',
      format: 'cjs'
    },
    plugins: esbuild()
  },
  // Build post source
  {
    external: (id) => !/^[./]/.test(id),
    input: 'src/post.ts',
    output: {
      file: 'build/post.js',
      format: 'cjs'
    },
    plugins: esbuild()
  }
]
