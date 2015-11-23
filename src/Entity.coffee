###
Generic game object class
All interactive objects in the demo extend this class

	Custom properties:
	==================
	deactivated   ""								entity will be deactivated on load
	targets 			"target1,target2" comma delimited string of target object IDs
	id 						"objectID" 				unique string

###

class Entity

	constructor: (@game, @layer, @data) ->
		# Container for linked objects by customer `id` property
		@targets = []

		@deactivated = false

		# Creates the Phaser Sprite based on the tile ID from Tiled
		@view = new Phaser.Sprite @game, 0, 0, 'sprites', @data.gid - 1

		# To keep our pixelated crisposity during scaling
		@view.smoothed = false;

		@view.anchor = new Phaser.Point 0.5, 0.5

		# Converts screen position to abstract tile coordinates for game logic
		@position = new Phaser.Point @data.x / options.tilesize, (@data.y / options.tilesize) - 1

		@updateViewPosition()

		if @data.properties.deactivated? then	@deactivate()
		else
			@deactivated = true
			@reactivate()

		return @

	###
	Moves the sprite to a tile position relative to the object's current position
	###
	moveRelative: (x, y) =>
		@position.x += x
		@position.y += y
		@updateViewPosition()
		return

	###
	Moves the sprite to a specific location
	###
	move: (x, y) =>
		@position.x = x
		@position.y = y
		@updateViewPosition()
		return

	###
	Using the tile coordinate, render the object at the appropriate screen position
	###
	updateViewPosition: () =>
		@view.x = @position.x * options.tilesize + options.tilesize / 2
		@view.y = @position.y * options.tilesize + options.tilesize / 2
		return

	###
	When a player interacts with this tile. Override.
	###
	onPlayerTouch: () =>
		return true
		return if @deactivated
		return

	###
	Removes the sprite from the game
	###
	deactivate: () =>
		return if @deactivated
		console.log 'deactivating'
		@deactivated = true
		if @view.parent?
			@view.parent.removeChild @view
		return

	###
	Adds the sprite to the game
	###
	reactivate: () =>
		return if !@deactivated
		@deactivated = false
		@layer.addChild @view
		return

module.exports = Entity
