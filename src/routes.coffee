environment = require '../config/environment'

exports.connect = (app) ->

  app.get '/', (req, res) ->
    res.render 'index', {}
