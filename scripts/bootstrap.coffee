# Description:
#   Loaded all current environment variables in redis when bootstrapping hubot

brain_key = "hubot-env"

module.exports = (robot) ->
  storageLoaded = =>
    loaded = robot.brain.get(brain_key)
    unless loaded
      console.log "hubot env bootstrap did nothing against empty data in redis"
      return

    for key, value of loaded.env
      process.env[key] = value
      console.log "hubot env bootstrap loaded #{key} => #{value}"

  robot.brain.on "loaded", storageLoaded
