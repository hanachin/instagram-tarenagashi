Twitter = require("ntwitter")
port = Number(process.env.PORT or 5000)

require("zappa") port, ->
  @enable "serve jquery"
  @get "/": ->
    @render "index"

  @view index: ->
    h1 "hello, world"

  @client "/index.js": ->
    @connect()
    @on tweet: ->
      url = "#{@data.entities.urls[0].expanded_url}media/?size=t"
      $("body").append $("<img/>").attr(src: url)
      console.log @data.text

  @view layout: ->
    doctype 5
    html ->
      head ->
        script src: "/zappa/jquery.js"
        script src: "/zappa/zappa.js"
        script src: "/socket.io/socket.io.js"
        script src: "/index.js"
        title "Hello, world"
      body @body

  twitter = new Twitter
    consumer_key: "1MBTo6FGuozQFI7xVz1vA"
    consumer_secret: "p0fO9JYh8Q6WGveaiZRz8L3ZukJ7VO7jJncjxDHBA"
    access_token_key: "500436817-v3xL9QlV6lmNeNnMxMbnXq3p0rXQ2LFt54Ysc"
    access_token_secret: "uIUIkU3JBhuYN7VsLxLgUU2nxaEUJC4Kfe9FxIYxg"

  twitter.stream "statuses/filter", {track:"instagr"}, (stream) =>
    stream.on "data", (tweet) =>
      @io.sockets.emit "tweet", tweet
