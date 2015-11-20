###
	Tile can move the player to different map locations
###
_ = require 'lodash'

Entity = require './Entity.coffee'

class Tile extends Entity
	constructor: (@game, @layer, @data) ->
		super @game, @layer, @data

		if @data.properties.times?
			times = @data.properties.times.split ','
			@activeTime = times[0]
			@inactiveTime = times[1]

			@delay = @data.properties.delay || 0
			@startTimer()

			window.addEventListener 'focus', @startTimer
			window.addEventListener 'blur', @stopTimer
		return @

	onPlayerTouch: (player) =>
		@player = player
		if @deactivated
			@killPlayer()
		return true

	deactivate: () =>
		super

		if @player? and @player.position.x == @position.x and @player.position.y == @position.y
			@killPlayer()
			return

		setTimeout @reactivate, @inactiveTime
		return

	reactivate: () =>
		super
		setTimeout @deactivate, @activeTime
		return

	killPlayer: () =>
		console.log 'you fell into blissful eternity'

		# restart the game state
		app.death @
		return

	startTimer: () =>
		@timerID = setTimeout @deactivate, (parseInt @activeTime) + (parseInt @delay)
		return

	stopTimer: () =>
		if @timerID?
			clearTimeout @timerID
		return

module.exports = Tile
