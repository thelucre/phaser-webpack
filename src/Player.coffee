###
	Player for the game
###
Entity = require './Test.coffee'

class Player extends Entity

	init: () =>
		super

		console.log @
		return @

module.exports = Player
