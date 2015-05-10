# Description:
#   Loads file of environment variables in process.env and redis
#
# Commands:
#   hubot env load --filename=[filename] --dry-run - Try loading [filename] of environment variables in process.env and redis
#   hubot env load --filename=[filename] - Loads [filename] of environment variables in process.env and redis

fs   = require 'fs'
path = require 'path'
env  = require 'node-env-file'
_    = require 'underscore'

brain_key = "hubot-env"

getArgParams = (arg) ->
    dry_run = if arg.match(/--dry-run/) then true else false

    filename_capture = /--filename=(.*?)( |$)/.exec(arg)
    filename = if filename_capture then filename_capture[1] else null

    return { dry_run : dry_run, filename: filename }

showLoadedEnv = (msg, prev_process_env) ->
  hidden_words = process.env.HUBOT_ENV_HIDDEN_WORDS
  hiddens = hidden_words.split(',') if hidden_words

  messages = []
  for key, value of process.env
    continue if key == 'ENV_FILE'
    continue if (key of prev_process_env) && (value == prev_process_env[key])
    if hiddens
      for hidden in hiddens
        value = '***' if key.match ///#{hidden}///i
    messages.push "#{key}=#{value}"

  message   = messages.join "\n"
  message ||= '[None]'
  msg.send message

saveInBrain = (robot, prev_process_env) ->
  loaded = robot.brain.get(brain_key) ? { env: {} }

  for key, value of process.env
    continue if key == 'ENV_FILE'
    continue if (key of prev_process_env) && (value == prev_process_env[key])
    loaded.env[key] = value

  robot.brain.set(brain_key, loaded)

showDetailBeforeApply = (msg, file_path) ->
  hidden_words = process.env.HUBOT_ENV_HIDDEN_WORDS
  hiddens = hidden_words.split(',') if hidden_words

  messages = []

  for line in fs.readFileSync(file_path, 'utf-8').toString().split('\n')
    key_value = line.split '='
    continue unless key_value.length == 2

    if hiddens
      for hidden in hiddens
        line = "#{key_value[0]}=***" if key_value[0].match ///#{hidden}///i
    messages.push "#{line}"

  message   = messages.join "\n"
  message ||= '[None]'
  msg.send message

module.exports = (robot) ->
  robot.respond /env load(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])

    dry_run    = arg_params.dry_run
    filename   = arg_params.filename
    unless filename
      msg.send "Error: Empty filename is invalid"
      return

    base_path = process.env.HUBOT_ENV_BASE_PATH || ''
    file_path = path.resolve base_path, filename
    unless fs.existsSync file_path
      msg.send "Error: Not Found #{file_path}"
      return

    msg.send "Loading env --filename=#{filename}, --dry-run=#{dry_run}..."

    if dry_run
      showDetailBeforeApply msg, file_path
      msg.send "Complete dry-run"
      return

    prev_process_env = _.clone process.env

    env file_path, {overwrite: true}

    showLoadedEnv msg, prev_process_env

    saveInBrain robot, prev_process_env
