# import global styles (to force a compile)
require 'style.styl'
require 'jquery'
Map = require './Map.coffee'

window.options =
	scale: 1
	tilesize: 8

class App

	constructor: () ->
		@filter = []
		@game = new Phaser.Game 160, 160, Phaser.AUTO, 'game', {
			preload: @preload
			create: @create
			update: @update
			render: @render
		}, true # transparent canvas

		@game.state.add('game', @)
		return @

	preload: () =>
		# load an asset file
		@game.load.image('tiles', '/assets/tiles.png');

		# load the Tiled map (with timestamp for cache busting)
		@game.load.tilemap 'map_01', '/assets/map_01.json?' + new Date(), null, Phaser.Tilemap.TILED_JSON

		@game.load.spritesheet('sprites', '/assets/tiles.png?' + new Date(), 8, 8, 16);

		@game.load.script('filter-filmgrain', '/assets/filters/filmgrain.js');

		return

	create: () =>

		@filter[0] = @game.add.filter('FilmGrain');
		@filter[0].size = 0.05;
		@filter[0].amount = 0.05;
		@filter[0].alpha = 0.05;

		# globalize input
		window.cursors = @game.input.keyboard.createCursorKeys()

		# Enabled pixel-perfect scaling :D
		Phaser.Canvas.setImageRenderingCrisp(@game.canvas)
		PIXI.scaleModes.DEFAULT = PIXI.scaleModes.NEAREST;

		@map = new Map @game

		# @game.stage.filters = [@filter[0]]

		return

	update: () =>
		@map.update()
		@filter[0].update()
		return

	render: () =>
		return


window.app = new App
