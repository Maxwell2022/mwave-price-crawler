# mwave-price-crawler
Quick and dirty price crawler for MWave (mwave.com.au)

# Installation
`npm install`

# Configuration
MWave items to crawl are located in: `config.coffee`

# How to run
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

# Reporting
At the moment the prices are displayed in the console and save in the data folder of your project. 
There is one file per day so you can keep and historic of the prices

# Todo
* handle the case where there is no prices on the page (ie. discontinued)

