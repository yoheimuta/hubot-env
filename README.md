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

## Configuration

Set environment variables like an example below.

```ruby
export HUBOT_ENV_BASE_PATH="${HOME}/files/env"
export HUBOT_ENV_HIDDEN_WORDS="SECRET_ACCESS_KEY,PASSWORD,TOKEN,API_KEY"
```

## Examples

Show current environment variables. You can limit to output with a prefix.

```ruby
hubot> hubot env current --prefix=HUBOT
HUBOT_GITHUB_TOKEN=***
HUBOT_ENV_HIDDEN_WORDS=SECRET_ACCESS_KEY,PASSWORD,TOKEN,API_KEY
HUBOT_AUTH_ADMIN=ADMIN
HUBOT_ENV_BASE_PATH=files/env
HUBOT_GITHUB_REPO=yoheimuta/hubot-env
HUBOT_CONCURRENT_REQUESTS=20
```

Show env files under HUBOT_ENV_BASE_PATH. You can select one in this list to load.

```ruby
hubot> hubot env file
aws-cred-account1.env
aws-cred-account2.env
```

Load new environment variables abount AWS credentials of account 1.

```ruby
hubot> hubot env load --filename=aws-cred-account1.env
Loading env --filename=aws-cred-account1.env, --dry-run=false...
HUBOT_AWS_CREDENTIALS=account1
HUBOT_AWS_ACCESS_KEY_ID=ACCESS_KEY1
HUBOT_AWS_SECRET_ACCESS_KEY=***
HUBOT_AWS_REGION=ap-northeast-1
```

Then, Switch to overwrite environment variables abount AWS credentials of account 2.

```ruby
hubot> hubot env load --filename=aws-cred-account2.env
Loading env --filename=aws-cred-account2.env, --dry-run=false...
HUBOT_AWS_CREDENTIALS=account2
HUBOT_AWS_ACCESS_KEY_ID=ACCESS_KEY2
HUBOT_AWS_SECRET_ACCESS_KEY=***
HUBOT_AWS_REGION=ap-northeast-1
```
