###
Generic game object class
All interactive objects in the demo extend this class
###

class Entity

	constructor: (@game, @layer, @data) -> 
		# Container for linked objects by customer `id` property
		@targets = []

		# Creates the Phaser Sprite based on the tile ID from Tiled
		@view = new Phaser.Sprite @game, 0, 0, 'sprites', @data.gid - 1
		@layer.addChild @view

		# To keep our pixelated crisposity during scaling
		@view.smoothed = false;

		@view.anchor = new Phaser.Point 0.5, 0.5

		# Converts screen position to abstract tile coordinates for game logic
		@position = new Phaser.Point @data.x / options.tilesize, (@data.y / options.tilesize) - 1

		@updateViewPosition()

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
		return if @deactivated
		return

	###
	Removes the sprite from the game
	###
	deactivate: () =>
		return if @deactivated
		@deactivated = true
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
