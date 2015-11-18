###
	Player for the game
###
Entity = require './Entity.coffee'

class Player extends Entity

	constructor: (@game, @map, @data) ->
		super @game, @map, @data
		return @

	update: () =>

		return

module.exports = Player
