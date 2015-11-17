# import global styles (to force a compile)
require 'style.styl'
Map = require './Map.coffee'

window.options =
	scale: 4
	tilesize: 8

class App

	constructor: () ->
		@game = new Phaser.Game 600, 600, Phaser.AUTO, 'game', {
			preload: @preload
			create: @create
			update: @update
			render: @render
		}, true # transparent canvas
		return @

	preload: () =>
		# load an asset file
		@game.load.image('tiles', '/assets/tiles.png');

		# load hte Tiled map
		@game.load.tilemap 'map_01', '/assets/map_01.json', null, Phaser.Tilemap.TILED_JSON

		@game.load.spritesheet('sprites', '/assets/tiles.png', 8, 8, 16);

		return

	create: () =>
		# globalize input
		window.cursors = @game.input.keyboard.createCursorKeys()

		# Enabled pixel-perfect scaling :D
		Phaser.Canvas.setImageRenderingCrisp(@game.canvas)
		PIXI.scaleModes.DEFAULT = PIXI.scaleModes.NEAREST;

		@map = new Map @game

		return

	update: () =>
		@map.update()
		return

	render: () =>
		return


window.app = new App
