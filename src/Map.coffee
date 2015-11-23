_ = require 'lodash'

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

		# render the static environment tiles
		@layers.environment = @map.createLayer 'environment'
		@layers.environment.setScale options.scale

		# setup a rednering layer for game objects
		@layers.objects = @map.createBlankLayer 'objects'
		@layers.objects.setScale options.scale

		@layers.player = @map.createBlankLayer 'player'
		@layers.player.setScale options.scale

		@layers.foreground = @map.createLayer 'foreground'
		@layers.foreground.setScale options.scale

		# get the Tiled map data for custom object loading
		@mapData = Phaser.TilemapParser.parse @game, 'map_01'

		# Build all map objects and views
		_.each @mapData.objects.objects, (object, i) =>
			@makeObject object

		# connect any objects that have targets (IE: Siwtches target other game objects)
		_.each @objects, (object) =>

			return unless object.data.properties.targets

			targets = object.data.properties.targets.split ','

			object.targets = @findById targets
			return

		return

	###
	Looks for any game objects that match an array of ID strings.
	The ID is a custom property set on Tiled Objects
	###
	findById: (targets) =>
		targetObjects = []

		_.each @objects, (object) =>
			return unless object.data.properties.id
			if (targets.indexOf(object.data.properties.id) >= 0)
				targetObjects.push object
			return

		return targetObjects

	###
	Create Coffee objects from Tiled Object layer data
	###
	makeObject: (object) =>
		# Player gets a special setup
		if object.name == 'player'
			@makePlayer object

		# Otherwise, build a custom instance (which will generate the Phaser sprite)
		else if @objectClasses[object.name]?
			@objects.push new @objectClasses[object.name]( @game, @layers.objects, object )

		# Or build a simple entity object (good for dummy tiles that can be activated or deactivated )
		else
			@objects.push new @objectClasses['entity']( @game, @layers.objects, object )

		return

	###
	Create a Player instance and bind input.
	We bind at the map level because movement is directly related to the
	map's environment.
	###
	makePlayer: (object) =>
		@player = new @objectClasses[object.name] @game, @layers.player, object

		cursors.up.onDown.add () =>
			if @isValidMove 0, -1
				@player.moveRelative 0,-1

		cursors.down.onDown.add () =>
			if @isValidMove 0,1
				@player.moveRelative 0,1

		cursors.left.onDown.add () =>
			if @isValidMove -1,0
				@player.moveRelative -1,0

		cursors.right.onDown.add () =>
			if @isValidMove 1,0
				@player.moveRelative 1,0

		return

	###
	Checks if hte player can move to a tile includes:
	A. If an object is at the upcoming position, trigger some interaction form the object
	B. If the map enviornment is a collision tile, don't let the player move there
	###
	isValidMove: (x,y) =>
		#  calculate the tile the player is moving to
		movePos = @player.position.clone()
		movePos.x += x
		movePos.y += y

		clean = true
		# check if any objects exist at that tile
		_.each @objects, (object) =>
			if object.position.x == movePos.x && object.position.y == movePos.y
				# the interaction object decides if the player should continue its move or not
				clean = object.onPlayerTouch @player
			return

		return clean && @mapData.layers[0].data[movePos.y][movePos.x].index != 6

module.exports = Map
