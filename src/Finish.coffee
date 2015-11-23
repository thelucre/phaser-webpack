###
	Our win condition
###
Entity = require './Test.coffee'

class Finish extends Entity

	onPlayerTouch: (player) =>
		console.log 'you beat this level'
		app.nextLevel()
		return true

module.exports = Finish
