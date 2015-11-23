###
	Tile can move the player to different map locations

	Custom properties:
	==================
	times   "activeTime,inactiveTime" comma strings in millis
	delay   "delay" in millis
###
_ = require 'lodash'

Entity = require './Entity.coffee'

STATE =
	WAITING: 0
	ACTIVE: 1
	INACTIVE: 2

class Tile extends Entity

	constructor: (@game, x, y, key, frame) ->
		super @game, x, y, key, frame
		return

	init: () =>
		super
		@state = STATE.WAITING
		@timer = 0

		# Grab timer properties from Tiled object data
		if @times?
			times = @times.split ','
			@activeTime = parseInt times[0]
			@inactiveTime = parseInt times[1]

			@delay = parseInt(@delay) || 0

			@timer = @game.time.create false
			@timer.add @delay, @runDelay, @
			@timer.start()

		return @

	###

	###
	runDelay: () =>
		@timer = @game.time.create false
		if @deactivated
			@timer.add @inactiveTime, @reactivate, @
		else
			@timer.add @activeTime, @deactivate, @
		@timer.start()
		return

	###
	Player should die if the tile is deactivated when they touch it
	###
	onPlayerTouch: (player) =>
		@player = player
		if !@active
			@killPlayer()
		return true

	###
	Kill the sprite and if the player is on this tile, them too X(
	###
	deactivate: () =>
		super

		if @player? and @player.coord.x == @coord.x and @player.coord.y == @coord.y
			@killPlayer()
			return

		if @times?
			@timer = @game.time.create false
			@timer.add @inactiveTime, @reactivate, @
			@timer.start()
		return

	###
	Re add the sprite to the scene and make the tile walkable
	###
	reactivate: () =>
		super

		if @times?
			@timer = @game.time.create false
			@timer.add @inactiveTime, @deactivate, @
			@timer.start()
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
