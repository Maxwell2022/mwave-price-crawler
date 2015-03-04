Crawler = require 'crawler'
url     = require 'url'
logger  = require './logger'

module.exports = new Crawler(
  maxConnections: 10
)