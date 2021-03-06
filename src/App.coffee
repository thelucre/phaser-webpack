# import global styles (to force a compile)
require 'style.styl'
require 'jquery'
Map = require './Map.coffee'

# Global game options
window.options =
	# Display object scaling
	scale: 1

	# Map titlesize, used to convert game logic position to screen position
	tilesize: 8

window.SETTINGS = require './Settings.coffee'

class App

	constructor: () ->
		@level = 6;

		@filter = []

		@game = new Phaser.Game 160, 160, Phaser.CANVAS, 'game', {
			preload: @preload
			create: @create
			update: @update
			render: @render
		}, true # transparent canvas

		# single state is the game state.
		# used to reload the entire scene on win/lose condition
		@game.state.add('game', @)
		return @

	preload: () =>
		# load the map's tilesheet
		@game.load.image('tiles', './assets/tiles.png?' + new Date());

		# load the Tiled map (with timestamp for cache busting)
		@game.load.tilemap 'map_01', './assets/map_0' + @level + '.json?' + new Date(), null, Phaser.Tilemap.TILED_JSON

		# load the tile sheet again (not a new request) to use individual tiles as Sprites
		@game.load.spritesheet('sprites', './assets/tiles.png?' + new Date(), 8, 8, 16);

		# load the demo Phaser filter, a noise effect
		@game.load.script('filter-filmgrain', './assets/filters/filmgrain.js');

		return

	create: () =>

		# setup up filter values
		@filter[0] = @game.add.filter('FilmGrain');
		@filter[0].size = 0.01;
		@filter[0].amount = 0.03;
		@filter[0].alpha = 0.01;

		# add the filter effect to the scene
		@game.stage.filters = [@filter[0]]

		# globalize keyboard input manager
		window.cursors = @game.input.keyboard.createCursorKeys()

		# Enabled pixel-perfect scaling :D
		Phaser.Canvas.setImageRenderingCrisp(@game.canvas)
		PIXI.scaleModes.DEFAULT = PIXI.scaleModes.NEAREST;
		@game.stage.smoothed = false
		Phaser.Canvas.setSmoothingEnabled @game.context, false

		#  create the map object
		@map = new Map @game

		return

	update: () =>
		@filter[0].update()
		return

	nextLevel: () =>
		@level++
		# restart the game state
		@game.state.start('game')

	death: (object, type) =>
		# Keep the player from moving on the death animation
		@map.stopInput()
		@map.stopObjects()

		if type == SETTINGS.DEATH.LASER
			tween = @game.add.tween(@map.player)
				.to( { alpha : 0, angle: 360 }, 2000, "Sine.easeOut")
				.start()
			@game.add.tween(@map.player.scale)
				.to( { x : 0, y: 0 }, 2000, "Sine.easeOut")
				.start()

			tween.onComplete.add @restart

		else if type == SETTINGS.DEATH.FALL
			tween = @game.add.tween(@map.player)
				.to( { alpha : 0, angle: 180 }, 2000, "Sine.easeOut")
				.onCompleteCallback @restart
				.start()
			@game.add.tween(@map.player.scale)
				.to( { x : 0, y: 0 }, 2000, "Sine.easeOut")
				.start()

			tween.onComplete.add @restart

		else
			@restart()
		return

	restart: () =>
		@game.state.start('game', true, false)
		return

window.app = new App
