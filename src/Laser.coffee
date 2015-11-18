###
	A simple dead zone
###
Entity = require './Entity.coffee'

class Laser extends Entity

	onPlayerTouch: () =>
		return if @deactivated
		console.log 'you died by laser'

		# restart the game state
		@game.state.start('game')
		return

module.exports = Laser
