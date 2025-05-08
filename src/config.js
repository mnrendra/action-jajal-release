'use strict'

const branches = [
  '+([0-9])?(.{+([0-9]),x}).x',
  'main',
  'next',
  { name: 'rc', prerelease: true },
  { name: 'beta', prerelease: true },
  { name: 'alpha', prerelease: true }
]

const plugins = [
  ['@semantic-release/exec', {
    publishCmd: './dist/scripts/publish.sh \'v${nextRelease.version}\' \'${nextRelease.notes}\''
  }],
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
  '@semantic-release/github',
  ['@semantic-release/npm', {
    tarballDir: '.'
  }],
  ['@semantic-release/git', {
    assets: ['package.json', 'package-lock.json'],
    message: 'release: v${nextRelease.version}\n\n${nextRelease.notes}'
  }],
  ['@semantic-release/exec', {
    prepareCmd: './dist/scripts/prepare.sh \'${nextRelease.version}\'',
    successCmd: './dist/scripts/success.sh \'v${nextRelease.version}\' \'${process.env.GITHUB_REPOSITORY}\''
  }]
]

const config = {
  branches,
  plugins
}

module.exports = config
