###
	Player for the game
###
Entity = require './Entity.coffee'

class Laser extends Entity

	constructor: (@game, @map, @data) ->
		super @game, @map, @data
		return @

	update: () =>

		return

	onPlayerTouch: () =>
		return if @deactivated
		console.log 'you died by laser'
		@game.state.start('game')
		return


module.exports = Laser
