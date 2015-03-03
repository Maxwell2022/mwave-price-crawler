_       = require 'underscore'
config  = require './config'
moment  = require 'moment'
logger  = require './lib/logger'
crawler = require './lib/crawler'
fs      = require 'fs'
tool    = require 'winston/lib/winston/config'

prices = []

# callback when the URL is crawled
callback = (error, result, $) ->
  # $ is Cheerio by default
  # a lean implementation of core jQuery designed specifically for the server
  label = $('span[itemprop=name]').html().trim()
  price = $('span[itemprop=price]').html().replace(/\$/, '')

  logger.info "Price for '" + result.options.item.name + "' (" + label + "): "+ tool.colorize('error', '$' + price)
  prices.push
    name: result.options.item.name
    price: parseFloat(price)
    label: label
  return

# callback when the queue is processed
queueProcessed = () ->
  obj = {}
  total = 0

  for item in prices
    total += item.price
    obj[item.name] =
      name: item.label
      price: item.price

  obj.total = total
  logger.info 'Total Amount: ' + tool.colorize('error', '$' + total)

  date = moment().format('YYYYMMDD')

  # Save the object in a file
  fs.writeFile './data/data-' + date + '.json', JSON.stringify(obj), {flag: 'w+'}, (err) ->
    if (err)
      return logger.error err
    logger.info 'File is saved'

  logger.info 'Queue Processed !!'

# set the crawler callback option
crawler.options.onDrain = queueProcessed

# add item into the queue
for item in config.items
  logger.info 'Queuing "' + item.name + '"...'
  crawler.queue prices: prices, item: item, uri: item.url, callback: callback


#
## Queue just one URL, with default callback
#c.queue 'http://joshfire.com'
#
## Queue a list of URLs
#c.queue [
#  'http://jamendo.com/'
#  'http://tedxparis.com'
#]
#
## Queue URLs with custom callbacks & parameters
#c.queue [ {
#  uri: 'http://parishackers.org/'
#  jQuery: false
#  callback: (error, result) ->
#    console.log 'Grabbed', result.body.length, 'bytes'
#    return
#} ]
#
## Queue using a function
#googleSearch = (search) ->
#  'http://www.google.fr/search?q=' + search
#c.queue uri: googleSearch('cheese')
#
## Queue some HTML code directly without grabbing (mostly for tests)
#c.queue [ { html: '<p>This is a <strong>test</strong></p>' } ]
