# Description:
#   List env files under HUBOT_ENV_BASE_PATH
#
# Commands:
#   hubot env file - List name of files under HUBOT_ENV_BASE_PATH

fs   = require 'fs'
path = require 'path'

module.exports = (robot) ->
  scripts_path = path.resolve __dirname, 'scripts'
  if fs.existsSync scripts_path
    robot.loadFile scripts_path, file for file in fs.readdirSync(scripts_path)

module.exports = (robot) ->
  robot.respond /env file$/i, (msg) ->
    base_path = process.env.HUBOT_ENV_BASE_PATH || ''

    messages = []

    if fs.existsSync base_path
      messages.push "#{file}" for file in fs.readdirSync(base_path)

    message   = messages.join "\n"
    message ||= '[None]'
    msg.send message
