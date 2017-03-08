# Description:
#   Pugme is the most important thing in life
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot pug me - Receive a pug
#   hubot pug bomb N - get N pugs

pugBaseUrl = 'http://pugme.herokuapp.com'
urlReplace = /[0-9][0-9].media/gi

module.exports = (robot) ->

  robot.respond /pug me/i, (msg) ->
    msg.http("#{pugBaseUrl}/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).pug.replace(urlReplace, 'media')

  robot.respond /pug bomb( (\d+))?/i, (msg) ->
    count = Number(msg.match[2] || 5)
    count = if count > 5 then 5 else count
    msg.http("#{pugBaseUrl}/bomb?count=" + count)
      .get() (err, res, body) ->
        msg.send pug.replace(urlReplace, 'media') for pug in JSON.parse(body).pugs

  robot.respond /how many pugs are there/i, (msg) ->
    msg.http("#{pugBaseUrl}/count")
      .get() (err, res, body) ->
        msg.send "There are #{JSON.parse(body).pug_count} pugs."
