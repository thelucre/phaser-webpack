###
	Switch can deactivate other objects
###
_ = require 'lodash'

Entity = require './Entity.coffee'

class Switch extends Entity

	onPlayerTouch: () =>
		console.log 'you hit the switch'
		_.each @targets, (target) =>
			if target.deactivated && @data.properties.toggle?
				target.reactivate()
			else
				target.deactivate()
		return true

module.exports = Switch
