fs   = require 'fs'
path = require 'path'

module.exports = (robot) ->
  scripts_path = path.resolve __dirname, 'scripts'
  if fs.existsSync scripts_path
    robot.loadFile scripts_path, file for file in fs.readdirSync(scripts_path)
