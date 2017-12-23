match  = require 'micromatch'
path   = require 'path'
fs     = require 'fs-extra'
type   = require 'path-type'
assert = require 'assert'

reporter = require './reporter.js'

flat = (arr) ->
	res = []
	f = (mas) ->
		for item in mas 
			if Array.isArray item
				f item
			else
				res.push item
	f arr
	res

class DB
	constructor: (@path) ->
		assert @path, 'Path must be defined!'

		@files = {}
		sf = @
		@index = 0

		Object.defineProperty @, '_map',
			get: ->
				r = []
				r.push index for index of sf.files

		Object.defineProperty @, '_exists',
			get: ->
				fs.pathExistsSync(sf.path) and 
				type.dirSync(sf.path)      and 
				fs.pathExistsSync(path.resolve sf.path, './map.json')

		if @_exists
			reporter.loading @path
			@_load()
		else
			reporter.creating @path
			@_init()

	_init: ->
		fs.mkdirpSync @path
		fs.writeFileSync path.resolve(@path, './map.json'), JSON.stringify @_map

	_load: ->
		text = fs.readFileSync
		map = JSON.parse

	write: ->
		for name, file of @files
			fs.writeFileSync path.resolve(@path, name), file
		fs.writeFileSync path.resolve(@path, './map.json'), JSON.stringify(@_map)


	add: ->
		for file in flat arguments
			@files[++@index] = file

module.exports = { DB }
