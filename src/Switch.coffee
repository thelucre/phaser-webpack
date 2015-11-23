###
	Switch can deactivate other objects

	Custom properties:
	==================
	toggle   "" will toggle targets activate/deactivate, not jsut a single fire

###
_ = require 'lodash'

Entity = require './Entity.coffee'

class Switch extends Entity

	onPlayerTouch: () =>
		console.log 'you hit the switch'
		_.each @targetObjs, (target) =>
			console.log target
			if !target.active && @toggle?
				target.reactivate()
			else
				target.deactivate()
		return true

module.exports = Switch
