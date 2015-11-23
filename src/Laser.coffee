###
	A simple dead zone
###
Entity = require './Entity.coffee'

class Laser extends Entity

	onPlayerTouch: () =>
		return true if !@active
		console.log 'you died by laser'

		# restart the game state
		app.death @
		return true

module.exports = Laser
