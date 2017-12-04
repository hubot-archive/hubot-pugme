// Description:
//   Pugme is the most important thing in life
//
// Dependencies:
//   None
//
// Configuration:
//   None
//
// Commands:
//   hubot pug me - Receive a pug
//   hubot pug bomb N - get N pugs

module.exports = function(robot) {

  robot.respond(/pug me/i, msg =>
    msg.http("http://pugme.herokuapp.com/random")
      .get()((err, res, body) => msg.send(JSON.parse(body).pug))
  );

  robot.respond(/pug bomb( (\d+))?/i, function(msg) {
    const count = msg.match[2] || 5;
    return msg.http(`http://pugme.herokuapp.com/bomb?count=${count}`)
      .get()((err, res, body) => Array.from(JSON.parse(body).pugs).map((pug) => msg.send(pug)));
  });

  return robot.respond(/how many pugs are there/i, msg =>
    msg.http("http://pugme.herokuapp.com/count")
      .get()((err, res, body) => msg.send(`There are ${JSON.parse(body).pug_count} pugs.`))
  );
};
