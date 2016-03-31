# Description:
#   Pugme is the most important thing in life
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_PUGBOMB_MAX - The most pugs you can bomb.  Default: 5
#
# Commands:
#   hubot pug me - Receive a pug
#   hubot pug bomb N - get N pugs

module.exports = (robot) ->
  pugBombLimit = parseInt(process.env.HUBOT_PUGBOMB_MAX) or 5

  robot.respond /pug me/i, (msg) ->
    msg.http("http://pugme.herokuapp.com/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).pug

  robot.respond /pug bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    if parseInt(count) > pugBombLimit
      msg.send "Sorry. That's too many pugs. Here's #{pugBombLimit} of them instead";
      count = pugBombLimit

    msg.http("http://pugme.herokuapp.com/bomb?count=" + count)
      .get() (err, res, body) ->
        msg.send pug for pug in JSON.parse(body).pugs

  robot.respond /how many pugs are there/i, (msg) ->
    msg.http("http://pugme.herokuapp.com/count")
      .get() (err, res, body) ->
        msg.send "There are #{JSON.parse(body).pug_count} pugs."
