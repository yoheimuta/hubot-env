# hubot-env

[![NPM](https://nodei.co/npm/hubot-env.png)](https://nodei.co/npm/hubot-env/)

Hubot manages environment variables dynamically in process.env and redis.

- load environment variables in process.env.
- store environment variables in redis.
- reload environment variables from redis to process.env in restarting hubot.
- flush all environment variables previously loaded via commands in process.env and redis.

If you use [hubot-aws](https://github.com/yoheimuta/hubot-aws) for example, you can switch environment variables about AWS Account Credentials via hubot command dynamically.

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
hubot env flush all - Flush all current environment variables in process.env and redis
hubot env flush all --dry-run - Try flushing all current environment variables in process.env and redis
hubot env load --filename=[filename] - Loads [filename] of environment variables in process.env and redis
hubot env load --filename=[filename] --dry-run - Try loading [filename] of environment variables in process.env and redis
```

## Configuration

Set environment variables like an example below.

```ruby
export HUBOT_ENV_BASE_PATH="${HOME}/example"
export HUBOT_ENV_HIDDEN_WORDS="SECRET_ACCESS_KEY,PASSWORD,TOKEN,API_KEY"
```

You can parepare your own env files by referring to the [example files](https://github.com/yoheimuta/hubot-env/tree/master/example).

## Examples

Display current environment variables. You can limit to output with a prefix.

```ruby
hubot> hubot env current --prefix=HUBOT
HUBOT_GITHUB_TOKEN=***
HUBOT_ENV_HIDDEN_WORDS=SECRET_ACCESS_KEY,PASSWORD,TOKEN,API_KEY
HUBOT_AUTH_ADMIN=ADMIN
HUBOT_ENV_BASE_PATH=files/env
HUBOT_GITHUB_REPO=yoheimuta/hubot-env
HUBOT_CONCURRENT_REQUESTS=20
```

Display env files under HUBOT_ENV_BASE_PATH. You can select one in this list to load.

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

Reload environment variables when restarting hubot.

```ruby
$ ./bin/hubot
hubot>
[Sun May 10 2015 16:19:20 GMT+0900 (JST)] INFO Using default redis on localhost:6379
[Sun May 10 2015 16:19:20 GMT+0900 (JST)] INFO Data for hubot brain retrieved from Redis
hubot env bootstrap loaded HUBOT_AWS_CREDENTIALS => account2
hubot env bootstrap loaded HUBOT_AWS_ACCESS_KEY_ID => ACCESS_KEY2
hubot env bootstrap loaded HUBOT_AWS_SECRET_ACCESS_KEY => ***
hubot env bootstrap loaded HUBOT_AWS_REGION => ap-northeast-1

hubot>
```

Flush all loaded environment variables.

```ruby
# Dry-run
hubot> hubot env flush all --dry-run
Flushing all --dry-run=true...
Complete dry-run: loadedData={
  HUBOT_AWS_CREDENTIALS: 'account2',
  HUBOT_AWS_ACCESS_KEY_ID: 'ACCESS_KEY2',
  HUBOT_AWS_SECRET_ACCESS_KEY: '***',
  HUBOT_AWS_REGION: 'ap-northeast-1' }

# Flush all
hubot> hubot env flush all
Flushing all --dry-run=false...
Complete flushing all

# Confirm to be flushed data in redis and process.env
hubot> hubot brain show storage --key=_private.hubot-env
null
hubot> hubot env current --prefix=HUBOT
HUBOT_GITHUB_TOKEN=***
HUBOT_ENV_HIDDEN_WORDS=SECRET_ACCESS_KEY,PASSWORD,TOKEN,API_KEY
HUBOT_AUTH_ADMIN=ADMIN
HUBOT_ENV_BASE_PATH=files/env
HUBOT_GITHUB_REPO=yoheimuta/hubot-env
HUBOT_CONCURRENT_REQUESTS=20
```

## Recommended Usage

### Use [hubot-brain-inspect](https://github.com/yoheimuta/hubot-brain-inspect)

`hubot-brain-inspect` displays data saved in redis with specifying by keys.

```ruby
hubot> hubot brain show storage --key=_private.hubot-env
{ env:
   { HUBOT_AWS_CREDENTIALS: 'account2',
     HUBOT_AWS_ACCESS_KEY_ID: 'ACCESS_KEY2',
     HUBOT_AWS_SECRET_ACCESS_KEY: '***',
     HUBOT_AWS_REGION: 'ap-northeast-1' } }
```
