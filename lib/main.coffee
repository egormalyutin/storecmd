{ DB }  = require './db.js'
path    = require 'path'
express = require 'express'

app = express()

db = new DB path.resolve __dirname, '../data'


app = express()

PORT = process.env.PORT or 3000

app.get '/:num', (req, res) ->
	file = db.files[req.params.num]
	if file
		res.send file
	else
		res.sendStatus 404

app.listen 3000, ->
	console.log('Example app listening on port 3000!');

