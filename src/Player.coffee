###
	Player for the game
###
class Player

	constructor: (@game, @map, data) ->

		@view = @game.add.sprite 0, 0, 'sprites'
		@view.smoothed = false;

		@position = new Phaser.Point data.x / options.tilesize, (data.y / options.tilesize) - 1
		@updateViewPosition()
		return @

	moveRelative: (x, y) =>
		@position.x += x
		@position.y += y
		@updateViewPosition()
		return

	updateViewPosition: () =>
		@view.x = @position.x * options.tilesize
		@view.y = @position.y * options.tilesize
		return

	update: () =>

		return

module.exports = Player
