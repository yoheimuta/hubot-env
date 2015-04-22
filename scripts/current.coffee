# Description:
#   Displays all current environment variables
#
# Commands:
#   hubot env current - Displays all current environment variables
#   hubot env current --prefix=[prefix] - Displays current environment variables with prefix

module.exports = (robot) ->
  robot.respond /env current($| --prefix=)(.*)$/i, (msg) ->
    prefix = msg.match[2].trim()

    hidden_words = process.env.HUBOT_ENV_HIDDEN_WORDS
    hiddens = hidden_words.split(',') if hidden_words

    messages = []
    for key, value of process.env
      continue unless key.match ///^#{prefix}.*///i
      if hiddens
        for hidden in hiddens
          value = '***' if key.match ///#{hidden}///i
      messages.push "#{key}=#{value}"

    message   = messages.join "\n"
    message ||= '[None]'
    msg.send message
