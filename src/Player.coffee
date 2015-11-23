###
	Player for the game
###
Entity = require './Entity.coffee'

class Player extends Entity

	init: () =>
		super

		console.log @
		return @

module.exports = Player
