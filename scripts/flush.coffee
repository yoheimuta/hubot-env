# Description:
#   Flush all current environment variables in process.env and redis
#
# Commands:
#   hubot env flush all --dry-run - Try flushing all current environment variables in process.env and redis
#   hubot env flush all - Flush all current environment variables in process.env and redis

util = require "util"

brain_key = "hubot-env"

getArgParams = (arg) ->
    dry_run = if arg.match(/--dry-run/) then true else false
    return { dry_run : dry_run }

module.exports = (robot) ->
  robot.respond /env flush all(.*)$/i, (msg) ->
    loaded = robot.brain.get(brain_key)
    unless loaded
      msg.send "Flush nothing against empty data in redis"
      return

    arg_params = getArgParams(msg.match[1])
    dry_run    = arg_params.dry_run

    msg.send "Flushing all --dry-run=#{dry_run}..."

    if dry_run
      loadedStr = util.inspect(loaded.env, false, null)
      msg.send "Complete dry-run: loadedData=#{loadedStr}"
      return

    for key, value of loaded.env
      delete process.env[key]

    robot.brain.set(brain_key, null)
    msg.send "Complete flushing all"
