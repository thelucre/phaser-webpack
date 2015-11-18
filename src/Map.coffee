_ = require 'lodash'

class Map
	constructor: (@game) ->

		@objectClasses =
			player: require './Player.coffee'
			laser: require './Laser.coffee'
			finish: require './Finish.coffee'
			switch: require './Switch.coffee'

		@objects = []

		# create a tilemap
		@map = @game.add.tilemap('map_01')

		@layers =
			environment: null
			objects: null

		# and load hte tileset into the map object
		@map.addTilesetImage 'tiles'

		# render the
		@layers.environment = @map.createLayer 'environment'
		@layers.environment.setScale options.scale

		@layers.objects = @map.createBlankLayer 'objects'
		@layers.objects.setScale options.scale

		@mapData = Phaser.TilemapParser.parse @game, 'map_01'

		# Build all map objects and views
		_.each @mapData.objects.objects, (object, i) =>
			@makeObject object

		# connect any objects that have targets (IE: Siwtches target other game objects)
		_.each @objects, (object) =>
			return unless object.data.properties.targets
			targets = object.data.properties.targets.split ','
			object.targets = @findById targets
			console.log object
			return

		return

	###

	###
	findById: (targets) =>
		targetObjects = []

		_.each @objects, (object) =>
			return unless object.data.properties.id
			if targets.indexOf object.data.properties.id >= 0
				targetObjects.push object
			return

		return targetObjects

	###

	###
	makeObject: (object) =>
		if object.name == 'player'
			@makePlayer object
		else
			@objects.push new @objectClasses[object.name]( @game, @layers.objects, object )
		return

	###

	###
	makePlayer: (object) =>
		@player = new @objectClasses[object.name] @game, @layers.objects, object

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
				object.onPlayerTouch()
				clean = false
			return

		return !clean || @mapData.layers[0].data[movePos.y][movePos.x].index != 6

	findObjectsByType: (type, map, layer) =>
		return

	update: () =>
		return

module.exports = Map
