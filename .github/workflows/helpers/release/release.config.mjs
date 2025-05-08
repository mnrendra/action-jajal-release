const branches = [
  '+([0-9])?(.{+([0-9]),x}).x',
  'main',
  'next',
  { name: 'rc', prerelease: true },
  { name: 'beta', prerelease: true },
  { name: 'alpha', prerelease: true }
]

const plugins = [
  ['@semantic-release/commit-analyzer', {
    releaseRules: [
      { type: 'docs', release: 'patch' },
      { type: 'style', release: 'patch' },
      { type: 'refactor', release: 'patch' },
      { type: 'perf', release: 'patch' },
      { type: 'test', release: 'patch' },
      { type: 'build', release: 'patch' },
      { type: 'ci', release: 'patch' },
      { type: 'chore', release: 'patch' },
      { type: 'revert', release: 'patch' }
    ]
  }],
  '@semantic-release/release-notes-generator',
  ['@semantic-release/exec', {
    prepareCmd: 'echo "prepare: ${nextRelease.version}" && git tag --list && git rev-parse HEAD',
    publishCmd: 'echo "publish: ${nextRelease.version}" && git tag --list && git rev-parse HEAD',
    successCmd: 'echo "success: ${nextRelease.version}" && git tag --list && git rev-parse HEAD'
  }]
]

const config = {
  branches,
  plugins
}

export default config
