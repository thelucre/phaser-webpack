class Entity

	constructor: (@game, @layer, data) ->
		@targets = []
		@view = new Phaser.Sprite @game, 0, 0, 'sprites', data.gid - 1
		@layer.addChild @view
		@view.smoothed = false;

		@position = new Phaser.Point data.x / options.tilesize, (data.y / options.tilesize) - 1
		@updateViewPosition()

		return @

	moveRelative: (x, y) =>
		@position.x += x
		@position.y += y
		@updateViewPosition()
		return

	updateViewPosition: () =>
		@view.x = @position.x * options.tilesize
		@view.y = @position.y * options.tilesize
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
