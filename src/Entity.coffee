###
Generic game object class
All interactive objects in the demo extend this class

	Custom properties:
	==================
	frameOverride "2"								tile index to override for spriting
	deactivated   ""								entity will be deactivated on load
	targets 			"target1,target2" comma delimited string of target object IDs
	id 						"objectID" 				unique string

###

class Entity extends Phaser.Sprite

	constructor: (@game, x, y, key, frame) ->
		super @game, x, y, key, frame
		return

	###
	Secondary init step because instance will not have Tiled properites until
	after the Sprite subclass constructor runs
	###
	init: ()=>

		# Container for linked objects by customer `id` property
		@targetObjs = []

		#  Keep a referenence to the original group parent
		@originalGroup = @parent;

		# To keep our pixelated crisposity during scaling
		@smoothed = false;

		# If the tile can interact with the player or not?
		@active = true;

		if @frameOverride?
			@frame = parseInt(@frameOverride)

		@coord = Phaser.Point.divide @position, (new Phaser.Point(options.tilesize,options.tilesize))

		if @deactivated? then @deactivate()
		else
			@deactivated = true
			@reactivate()
		return @

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
		return if !@active
		console.log 'deactivating'
		@active = false
		@visible = false
		return

	###
	Adds the sprite to the game
	###
	reactivate: () =>
		return if @active
		console.log 'reactivating'
		@active = true
		@visible = true
		return

	###
	Moves the sprite to a tile position relative to the object's current position
	###
	moveRelative: (x, y) =>
		@coord.x += x
		@coord.y += y
		@updateViewPosition()
		return

	###
	Moves the sprite to a specific location
	###
	move: (x, y) =>
		@coord.x = x
		@coord.y = y
		@updateViewPosition()
		return

	###
	Using the tile coordinate, render the object at the appropriate screen position
	###
	updateViewPosition: () =>
		@position = Phaser.Point.multiply @coord, (new Phaser.Point(options.tilesize,options.tilesize))
		return

module.exports = Entity
