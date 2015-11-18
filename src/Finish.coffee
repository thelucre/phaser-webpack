###
	Player for the game
###
Entity = require './Entity.coffee'

class Finish extends Entity

	constructor: (@game, @layer, @data) ->
		super @game, @layer, @data
		return @

	update: () =>

		return

	onPlayerTouch: () =>
		console.log 'you beat this level'
		@game.state.start('game')
		return

module.exports = Finish
