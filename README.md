# hubot-env

[![NPM](https://nodei.co/npm/hubot-env.png)](https://nodei.co/npm/hubot-env/)

Hubot reads environment variables

## Installation

Add **hubot-env** to your `package.json` file:

```
npm install --save hubot-env
```

Add **hubot-env** to your `external-scripts.json`:

```json
["hubot-env"]
```

Run `npm install`

## Commands

```ruby
hubot env current - Displays all current environment variables
hubot env current --prefix=[prefix] - Displays current environment variables with prefix
hubot env file - List name of files under HUBOT_ENV_BASE_PATH
hubot env load --filename=[filename] - Loads [filename] of environment variables
hubot env load --filename=[filename] --dry-run - Try loading [filename] of environment variables
```
