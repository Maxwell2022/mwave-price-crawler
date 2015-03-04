environment  = require './config/environment'
express      = require 'express'
cookieParser = require 'cookie-parser'
session      = require 'express-session'
favicon      = require 'serve-favicon'
bodyParser   = require 'body-parser'
path         = require 'path'
routes       = require './src/routes'
errorHandler = require './src/middleware/errorHandler'
exphbs       = require 'express3-handlebars'

# Setup the application
app = module.exports = express()

app.engine 'hbs', exphbs
  extname: '.hbs'
app.set 'port', environment.server.port
app.set 'views', "#{__dirname}/src/views"
app.set 'view engine', '.hbs'

app.use(session(
  resave: true
  saveUninitialized: true
  secret: environment.server.session.secret
))

app.use cookieParser environment.server.secret
app.use bodyParser.json()
app.use bodyParser.urlencoded {extended: true}
app.use express.static("#{__dirname}/public")
app.use favicon "#{__dirname}/public/images/favicon.ico"

# Setup the routes
routes.connect app

# Handle Errors
app.use errorHandler