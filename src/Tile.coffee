###
	Tile can move the player to different map locations

	Custom properties:
	==================
	times   "activeTime,inactiveTime" comma strings in millis
	delay   "delay" in millis
###
_ = require 'lodash'

Entity = require './Entity.coffee'

class Tile extends Entity

	constructor: (@game, @layer, @data) ->
		super @game, @layer, @data

		# Grab timer properties from Tiled object data
		if @data.properties.times?
			times = @data.properties.times.split ','
			@activeTime = times[0]
			@inactiveTime = times[1]

			@delay = @data.properties.delay || 0
			@startTimer()

			# To handle window blurs messing up timeOuts, stop all
			# timers on window exit and readd them on focus
			window.addEventListener 'focus', @startTimer
			window.addEventListener 'blur', @stopTimer
		return @

	###
	Player should die if the tile is deactivated when they touch it
	###
	onPlayerTouch: (player) =>
		@player = player
		if @deactivated
			@killPlayer()
		return true

	###
	Kill the sprite and if the player is on this tile, them too X(
	###
	deactivate: () =>
		super

		if @player? and @player.position.x == @position.x and @player.position.y == @position.y
			@killPlayer()
			return

		if @data.properties.times?
			# Ignite the timer to reactivate the tile
			@timerID = setTimeout @reactivate, @inactiveTime
		return

	###
	Re add the sprite to the scene and make the tile walkable
	###
	reactivate: () =>
		super

		if @data.properties.times?
			# Ignite the timer to deactivate the tile
			@timerID = setTimeout @deactivate, @activeTime
		return

	###
	Player dies
	###
	killPlayer: () =>
		console.log 'you fell into blissful eternity'
		@stopTimer()
		# restart the game state
		app.death @
		return

	###
	Builds a timer for deactivating the tile
	###
	startTimer: () =>
		@timerID = setTimeout @deactivate, (parseInt @activeTime) + (parseInt @delay)
		return

	###
	Kills the timer, if any is set
	###
	stopTimer: () =>
		if @timerID?
			clearTimeout @timerID
		return

module.exports = Tile
