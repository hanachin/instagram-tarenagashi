port = Number(process.env.PORT or 5000)

require("zappa") port, ->
  @get "/": ->
    "Hello, world"
