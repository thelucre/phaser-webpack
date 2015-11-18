###
	Warp can move the player to different map locations
###
_ = require 'lodash'

Entity = require './Entity.coffee'

class Warp extends Entity

	onPlayerTouch: (player) =>
		console.log 'you hit the warp'
		if(@targets.length > 0)
			pos = @targets[0].position
			player.move pos.x, pos.y
			return false
		return true

module.exports = Warp
