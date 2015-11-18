###
	Our win condition
###
Entity = require './Entity.coffee'

class Finish extends Entity

	onPlayerTouch: () =>
		console.log 'you beat this level'
		app.nextLevel()
		return true

module.exports = Finish
