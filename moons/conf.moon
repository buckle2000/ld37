DEBUG = false
unless DEBUG
  print = ->

love.conf = (t) ->
  t.console = DEBUG
  t.version = "0.10.1"

  t.window.title = "fish.zip"
  t.window.width = 640
  t.window.height = 640

  love._conf = t
