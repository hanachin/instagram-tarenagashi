Twitter = require("ntwitter")
port = Number(process.env.PORT or 5000)

require("zappa") port, ->
  @use 'static'

  @enable "serve jquery"

  @get "/json": ->
    JSON.stringify key:"value", foo:"bar"

  @view "hello.eco": """
    <% @title = 'eco test' %>
    <h1><%= @title %></h1>
  """

  @get "/something": ->
    @render "hello.eco", layout: no

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
        script src: "/hello.js"
        title "Hello, world"
      body @body

  twitter = new Twitter
    consumer_key: process.env.CONSUMER_KEY
    consumer_secret: process.env.CONSUMER_SECRET
    access_token_key: process.env.ACCESS_TOKEN_KEY
    access_token_secret: process.env.ACCESS_TOKEN_SECRET

  twitter.stream "statuses/filter", {track:"instagr"}, (stream) =>
    stream.on "data", (tweet) =>
      @io.sockets.emit "tweet", tweet
