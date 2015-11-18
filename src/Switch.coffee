###
	Switch can deactivate other objects
###
_ = require 'lodash'

Entity = require './Entity.coffee'

class Switch extends Entity

	onPlayerTouch: () =>
		console.log 'you hit the switch'
		_.each @targets, (target) =>
			target.deactivate()
		return

module.exports = Switch
