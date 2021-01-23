# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2020-01-23

- Major refactor for performance
- Massive write of the the gems config
- Added and refactored tests
- 'object.present?` is no longer defined out of the box, only if it doesn't exist in the codebase already _(prevents causing errors with Rails)_


## [0.0.3] - 2019-10-16

- Add timeout to the API requests