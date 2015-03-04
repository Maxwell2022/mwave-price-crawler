module.exports =
  logging:
    console:
      level: 'debug'
  server:
    port: process.env.PORT or 3000
    session:
      secret: "mwave"