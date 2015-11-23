###
	Warp can move the player to different map locations
###
_ = require 'lodash'

Entity = require './Test.coffee'

class Warp extends Entity

	onPlayerTouch: (player) =>
		console.log 'you hit the warp'
		if(@targetObjs.length > 0)
			console.log @targetObjs[0]
			pos = @targetObjs[0].coord
			player.move pos.x, pos.y
			return false
		return true

module.exports = Warp
