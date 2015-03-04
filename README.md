# mwave-price-crawler
Quick and dirty price crawler for MWave (mwave.com.au)
This crawler is using [node-crawler](https://github.com/sylvinus/node-crawler) project in order to crawl pages

## Installation
`npm install`

## Configuration
MWave items to crawl are located in: `source.coffee`
You can setup multiple configuration if you wish

## How to run
I'm using CoffeeScript so you can either install it globally:

```
npm install -g coffee-script
```

and then run:

```
coffee crawler.coffee
```

Or use the local installation of coffee-script

```
./node_modules/.bin/coffee crawler.coffee
```

## Reporting
At the moment the prices are displayed in the console and save in the data folder of your project. 
There is one file per configuration so you can keep and history of the prices on a daily basis for each configuration

## Todo
* handle the case where there is no prices on the page (ie. discontinued)
* chart to see price fluctuation
