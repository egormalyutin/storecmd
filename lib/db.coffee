match  = require 'micromatch'
path   = require 'path'
fs     = require 'fs-extra'
type   = require 'path-type'
assert = require 'assert'

DATA = './data.json'

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

		Object.defineProperty @, '_exists',
			get: ->
				fs.pathExistsSync(sf.path) and 
				type.dirSync(sf.path)      and 
				fs.pathExistsSync(path.resolve sf.path, DATA)

		Object.defineProperty @, '_data',
			get: ->
				index: sf.index
				files: index for index of sf.files

		if @_exists
			reporter.loading @path
			@_load()
		else
			reporter.creating @path
			@_init()

		@_proxify()

	# DASH

	_init: ->
		fs.mkdirpSync @path
		fs.writeFileSync path.resolve(@path, DATA), JSON.stringify @_data

	_load: ->
		text   = fs.readFileSync path.resolve(@path, DATA)
		data   = JSON.parse text
		files  = data.files
		@index = data.index

		for file in files
			@files[file] = fs.readFileSync(path.resolve(@path, './' + file)).toString()

	_proxify: ->
		sf = @
		@files = new Proxy @files,
			get: (obj, prop) ->
				obj[prop]
			set: (obj, prop, value) ->
				obj[prop] = value
				sf.write prop, value 
				return obj[prop]
			deleteProperty: (obj, prop) ->
				delete obj[prop]
				sf._delete prop
				return

	_delete: (file) ->
		fs.removeSync path.resolve(@path, file)
		fs.writeFileSync path.resolve(@path, DATA), JSON.stringify(@_data)


	write: (prop, value) ->
		fs.re
		if prop? and value?
			fs.writeFileSync path.resolve(@path, prop), value
		else
			for name, file of (@files)
				fs.writeFileSync path.resolve(@path, name), file
		fs.writeFileSync path.resolve(@path, DATA), JSON.stringify(@_data)

	add: ->
		for file in flat arguments
			@files[++@index] = file

	push: @::add

module.exports = { DB }
