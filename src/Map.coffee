_ = require 'lodash'
Test = require './Test.coffee'

class Map
	constructor: (@game) ->

		# Coffeescript classes to create game object instances
		@objectClasses =
			entity: require './Entity.coffee'
			player: require './Player.coffee'
			laser: require './Laser.coffee'
			finish: require './Finish.coffee'
			switch: require './Switch.coffee'
			warp: require './Warp.coffee'
			tile: require './Tile.coffee'

		# container for objects created from Tiled map data
		@objects = []

		# create a tilemap from our demo json map
		@map = @game.add.tilemap('map_01')

		@layers =
			environment: null
			objects: null
			player: null

		# and load hte tileset into the map object
		@map.addTilesetImage 'tiles'

		console.log @map

		# render the static environment tiles
		@layers.environment = @map.createLayer 'environment'
		@layers.environment.setScale options.scale

		# Groups of objects will hold instance of game logic classes
		@objectGroup = @game.add.group()
		@playerGroup = @game.add.group()

		@map.createFromObjects('objects', 'player', 'sprites', 0, true, true, @playerGroup, @objectClasses.player)
		@map.createFromObjects('objects', 'laser', 'sprites', 1, true, true, @objectGroup, @objectClasses.laser)
		@map.createFromObjects('objects', 'finish', 'sprites', 2, true, true, @objectGroup, @objectClasses.finish)
		@map.createFromObjects('objects', 'warp', 'sprites', 6, true, true, @objectGroup, @objectClasses.warp)
		@map.createFromObjects('objects', 'switch', 'sprites', 3, true, true, @objectGroup, @objectClasses.switch)
		@map.createFromObjects('objects', 'tile', 'sprites', 3, true, true, @objectGroup, @objectClasses.tile)
		# @map.createFromObjects('objects', 'switch', 'sprites', 3, true, true, @objectGroup, @objectClasses.switch)

		@layers.foreground = @map.createLayer 'foreground'
		if @layers.foreground?
			@layers.foreground.setScale options.scale


		# init game object instances
		_.each @playerGroup.children, (obj) =>
			@makePlayer obj

		_.each @objectGroup.children, (obj) =>
			obj.init()

		# connect any objects that have targets (IE: Siwtches target other game objects)
		_.each @objectGroup.children, (obj) =>

			return unless obj.targets

			targets = obj.targets.split ','

			obj.targetObjs = @findById targets
			return

		return

	###
	Looks for any game objects that match an array of ID strings.
	The ID is a custom property set on Tiled Objects
	###
	findById: (targets) =>
		targetObjects = []

		_.each @objectGroup.children, (object) =>
			return unless object.id?
			if (targets.indexOf(object.id) >= 0)
				targetObjects.push object
			return

		return targetObjects

	###
	Create a Player instance and bind input.
	We bind at the map level because movement is directly related to the
	map's environment.
	###
	makePlayer: (obj) =>
		@player = obj.init()

		cursors.up.onDown.add () =>
			if @isValidMove 0, -1
				obj.moveRelative 0,-1

		cursors.down.onDown.add () =>
			if @isValidMove 0,1
				obj.moveRelative 0,1

		cursors.left.onDown.add () =>
			if @isValidMove -1,0
				obj.moveRelative -1,0

		cursors.right.onDown.add () =>
			if @isValidMove 1,0
				obj.moveRelative 1,0
		return

	###
	Checks if the player can move to a tile includes:
	A. If an object is at the upcoming position, trigger some interaction form the object
	B. If the map enviornment is a collision tile, don't let the player move there
	###
	isValidMove: (x,y) =>
		#  calculate the tile the player is moving to
		movePos = @player.coord.clone()
		movePos.x += x
		movePos.y += y

		clean = true
		# check if any objects exist at that tile
		_.each @objectGroup.children, (object) =>

			if object.coord.x == movePos.x && object.coord.y == movePos.y
				# the interaction object decides if the player should continue its move or not
				clean = object.onPlayerTouch @player
			return

		return clean && @map.layers[0].data[movePos.y][movePos.x].index != 6

module.exports = Map
