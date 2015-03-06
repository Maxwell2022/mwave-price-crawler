_       = require 'underscore'
config  = require './config/environment'
sources = require './source'
moment  = require 'moment'
logger  = require './src/lib/logger'
crawler = require './src/lib/crawler'
fs      = require 'fs'
tool    = require 'winston/lib/winston/config'

prices = {}

# Slugify string
slugify = (string) ->
  string.toString().toLowerCase().replace(/\s+/g, '-').replace(/[^\w\-]+/g, '').replace(/\-\-+/g, '-').trim()


# callback when the URL is crawled
callback = (error, result, $) ->
  # $ is Cheerio by default
  # a lean implementation of core jQuery designed specifically for the server
  try
    label = $('span[itemprop=name]')?.html()?.trim()
    price = $('span[itemprop=price]')?.html()?.replace(/\$/, '')
  catch err
    label = 'Couldn\'t find the requested item'
    price = 0

  price = parseFloat(price) or 0
  logger.info "Price for '" + result.options.item.name + "' (" + label + "): "+ tool.colorize('error', '$' + price)
  result.options.prices.push
    name: result.options.item.name
    price: price
    label: label
  return

# callback when the queue is processed
queueProcessed = () ->
  obj = {}
  total = 0
  date = moment().format('YYYYMMDDHH')

  for configuration of prices
    logger.info 'Summary of configuration "' + tool.colorize('error', configuration) + '"'

    for item in prices[configuration]
      total += item.price
      obj[item.name] =
        name: item.label
        price: item.price

    obj.total = total
    logger.info 'Total Amount: ' + tool.colorize('error', '$' + total)

    # Get the configuration data
    file = './data/data-' + (slugify configuration) + '.json'

    # Try to get the current data for the current configuration
    fs.readFile file, 'utf-8', (err, data) ->
      if err
        data = {}
      else
        data = JSON.parse data

      data[date] = obj

      # Save the object in a file
      fs.writeFile file, JSON.stringify(data), {flag: 'w+'}, (err) ->
        if (err)
          return logger.error err
        logger.info 'Configuration ' + configuration + ' is saved'

  logger.info 'Queue Processed !!'

# set the crawler callback option
crawler.options.onDrain = queueProcessed

exports.crawl = () ->
  for configuration in sources
    # Init configuration prices
    prices[configuration.name] = []

    # Add item into the queue
    for item in configuration.items
      logger.info 'Queuing "' + item.name + '"...'
      crawler.queue prices: prices[configuration.name], item: item, uri: item.url, callback: callback

# {"20150303":{"WIFI":{"name":"TP-LINK TL-WDN3800 N600 Wireless Dual Band PCI Express Adapter","price":35},"Motherboard":{"name":"ASUS Gryphon Z97 ARMOR Edition Intel LGA 1150 Motherboard","price":219},"Cooling":{"name":"NZXT Kraken X61 Liquid CPU Cooler - RL-KRX61-01","price":159},"Case":{"name":"Fractal Design Define R5 Mid Tower Case - Black","price":159},"CPU":{"name":"Intel Core i7 4790 Quad Core LGA 1150 3.6GHz CPU Processor","price":428.99},"Hard Drive - SSD":{"name":"Samsung 840 EVO 250GB 2.5&quot; SATA III SSD MZ-7TE250BW","price":175.99},"Memory":{"name":"Kingston HyperX FURY 16GB (2x 8GB) DDR3 1866MHz Memory Red HX318C10FRK2/16","price":199},"Power Supply":{"name":"Bitfenix Fury 750W 80 Plus GOLD Modular Power Supply","price":189},"Graphic Card":{"name":"Galax GeForce GTX 970 EX OC Black Edition V2 4GB Video Card","price":515.98},"Hard Drive - Storage":{"name":"Seagate ST1000DM003 1TB Barracuda Desktop HDD 3.5&#x201D; 7200RPM SATA3 Hard Drive","price":74.99},"Keyboard":{"name":"Logitech Desktop K120 Keyboard USB (920-002582)","price":15.5},"Screen":{"name":"BenQ GW2765HT (IPS) 27&quot; 2560 x 1440 4ms DisplayPort Low Blue Light LED Monitor","price":529},"total":2700.45}}