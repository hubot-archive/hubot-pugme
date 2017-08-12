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
#   hubot pug bomb N - Get N pugs

module.exports = (robot) ->
  robot.respond /pug me|pug bomb( (\d+))?/i, (msg) ->
    count = msg.match[2]
    if not count
      count = if (msg.match.input.match /bomb/i)? then 5 else 1

    robot.http("https://www.reddit.com/r/pugs.json?sort=top&t=week")
      .get() (error, response, body) ->
        if error?
          robot.logger.error(error)
          msg.reply "I'm brain damaged :("
          return

        if response.statusCode >= 400
          txt = "[#{response.statusCode}] #{response.statusMessage}"
          robot.logger.error(txt)
          msg.reply "I'm brain damaged :("
          return
          
        try
          pugs = getPugs(body, count)
        catch error
          robot.logger.error "[pugme] #{error}"
          msg.reply "I'm brain damaged :("
          return

        msg.reply pug for pug in pugs

imgurAlbumRegex = /imgur\.com\/a\//i
imgurDirectLinkRegex = /i\.imgur\.com/i
imgurReplaceRegex = /\.imgur\.com\/(.+)/i
imageRegex = /^(https?:\/\/.+\/(.+)\.(jpg|png|gif|jpeg$))/

getPugs = (response, n) ->
  try
    posts = JSON.parse response
  catch error
    throw new Error "JSON parse failed"

  unless posts.data?.children? && posts.data.children.length > 0
    throw new Error "Could not find any posts"

  imagePosts = posts.data.children.filter((child) -> not child.data.is_self)

  # filter out imgur album links
  imagePosts = imagePosts.filter((imagePost) ->
    return not imgurAlbumRegex.test(imagePost.data.url))
  # convert non-direct image links on imgur to direct links.
  for imagePost in imagePosts
    if not imgurDirectLinkRegex.test(imagePost.data.url)
      imagePost.data.url =
        imagePost.data.url.replace(imgurReplaceRegex, "i.imgur.com/$1.jpg")

  # remove all other posts that are not images.
  imagePosts = imagePosts.filter((imagePost) ->
    return imageRegex.test(imagePost.data.url))

  if n > imagePosts.length
    n = imagePosts.length

  return (imagePost.data.url for imagePost in (sample(imagePosts, n)))


sample = (array, n) ->
  if not Array.isArray(array)
    throw new Error("Argument 'array' is not an array.")

  if n >= array.length
    return array

  items = []

  if n <= 0
    return items

  for [1..n]
    index = Math.floor(Math.random()*array.length)
    item = array[index]
    lastItem = array.pop()
    array[index] = lastItem
    items.push(item)

  return items
