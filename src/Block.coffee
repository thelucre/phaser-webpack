###
	A simple dead zone
###
Entity = require './Entity.coffee'

class Block extends Entity
	onPlayerTouch: (@player, map) =>
		x = @coord.x + (@coord.x - @player.coord.x)
		y = @coord.y + (@coord.y - @player.coord.y)
		if @checkValid map, x, y
			@move x, y
			return true
		return false

	checkValid: (map, x, y) =>
		return map.map.layers[0].data[y][x].index != 6

module.exports = Block
