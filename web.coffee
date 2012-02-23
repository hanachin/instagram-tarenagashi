port = Number(process.env.PORT or 5000)

require("zappa") port, ->
  @get "/": ->
    @render "index"

  @view index: ->
    h1 "hello, world"

  @view layout: ->
    doctype 5
    html ->
      head ->
        title "Hello, world"
      body @body
