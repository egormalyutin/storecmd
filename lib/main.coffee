
{ DB } = require './db.js'
path   = require 'path'

db = new DB path.resolve __dirname, '../data'

db.add 'lalka', 'lolka'

db.write()

console.log db
