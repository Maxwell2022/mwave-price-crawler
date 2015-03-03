config  = require '../config'
winston = require 'winston'
moment  = require 'moment'

# Console Logging
transports = []
transports.push new (winston.transports.Console)(
  level: config.logging.console.level
  colorize: true
  prettyPrint: true
  timestamp: ->
    return moment().format()
)

logger = new winston.Logger(
  levels:
    debug: 0
    info: 1
    warning: 2
    error: 3
  colors:
    debug: 'cyan'
    info: 'magenta'
    warning: 'yellow'
    error: 'red'
  transports: transports
)

module.exports = logger