_ = require 'lodash'
Player = require './Player.coffee'

class Map
	constructor: (@game) ->

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

		_.each @mapData.objects.objects, (object, i) =>
			switch object.name
				when 'player' then @makePlayer object
			return
		return

	makePlayer: (object) =>
		@player = new Player @game, @map, object
		@layers.objects.addChild @player.view

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

	isValidMove: (x,y) =>
		movePos = @player.position.clone()
		movePos.x += x
		movePos.y += y
		return @mapData.layers[0].data[movePos.y][movePos.x].index != 6

	findObjectsByType: (type, map, layer) =>
		return

	update: () =>
		return

module.exports = Map
