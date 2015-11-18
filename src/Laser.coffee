###
	A simple dead zone
###
Entity = require './Entity.coffee'

class Laser extends Entity

	onPlayerTouch: () =>
		return true if @deactivated
		console.log 'you died by laser'

		# restart the game state
		@game.state.start('game')
		return true

module.exports = Laser
