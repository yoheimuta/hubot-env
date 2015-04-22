# Description:
#   Loads file of environment variables
#
# Commands:
#   hubot env load --filename=[filename] --dry-run - Try loading [filename] of environment variables
#   hubot env load --filename=[filename] - Loads [filename] of environment variables

fs   = require 'fs'
path = require 'path'
env  = require 'node-env-file'
_    = require 'underscore'

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
  robot.respond /env load --filename=(.*?)(| --dry-run)$/i, (msg) ->
    filename = msg.match[1].trim() || ''
    dry_run  = if msg.match[2] then true else false

    base_path = process.env.HUBOT_ENV_BASE_PATH || ''
    file_path = path.resolve base_path, filename
    unless fs.existsSync file_path
      msg.send "Error: Not Found #{file_path}"
      return

    msg.send "Loading env --filename=#{filename}, --dry-run=#{dry_run}..."

    if dry_run
      showDetailBeforeApply msg, file_path
      return

    prev_process_env = _.clone process.env

    env file_path, {overwrite: true}

    showLoadedEnv msg, prev_process_env
