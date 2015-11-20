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

class App

	constructor: () ->
		@level = 1;

		@filter = []

		@game = new Phaser.Game 160, 160, Phaser.AUTO, 'game', {
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
		@filter[0].size = 0.05;
		@filter[0].amount = 0.05;
		@filter[0].alpha = 0.05;

		# add the filter effect to the scene
		@game.stage.filters = [@filter[0]]

		# globalize keyboard input manager
		window.cursors = @game.input.keyboard.createCursorKeys()

		# Enabled pixel-perfect scaling :D
		Phaser.Canvas.setImageRenderingCrisp(@game.canvas)
		PIXI.scaleModes.DEFAULT = PIXI.scaleModes.NEAREST;

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

	death: (object) =>
		@game.state.start('game')
		return

window.app = new App
