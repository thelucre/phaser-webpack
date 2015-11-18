###
	Our win condition
###
Entity = require './Entity.coffee'

class Finish extends Entity

	onPlayerTouch: () =>
		console.log 'you beat this level'

		# restart the game state
		@game.state.start('game')
		return

module.exports = Finish
