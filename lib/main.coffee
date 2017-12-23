{ DB }  = require './db.js'
path    = require 'path'
express = require 'express'


db = new DB path.resolve __dirname, '../data'

app  = express()
PORT = process.env.PORT or 3000

app.get '/get/:num', (req, res) ->
	file = db.files[req.params.num]
	if file
		res.send file
	else
		res.sendStatus 404

app.put '/add', (req, res) ->
	console.log res.locals.content
	db.add req.body
	res.send 'Succeful!!'

app.listen 3000, ->
	console.log('Example app listening on port 3000!');

