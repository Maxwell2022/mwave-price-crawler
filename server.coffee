environment = require './config/environment'
app         = require './app'
logger      = require './src/lib/logger'
crawler     = require './crawler'

server = app.listen environment.server.port, ->
  logger.info 'Express server listening on port ' + environment.server.port
  logger.info 'Process ID: ' + process.pid

  # Crawl every hour
  logger.info 'Crawler scheduler started...'
  setTimeout(crawler.crawl(), 60*60*1000)