{ DB }  = require './db.js'
path    = require 'path'
express = require 'express'

app = express()

db = new DB path.resolve __dirname, '../data'

db.push 'lsl'

PORT = process.env.PORT or 8000

app.listen PORT

console.log 'Listening on ' + PORT + '!'
