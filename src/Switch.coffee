###
	Switch can deactivate other objects
###
_ = require 'lodash'

Entity = require './Entity.coffee'

class Switch extends Entity

	constructor: (@game, @layer, @data) ->
		super @game, @layer, @data
		return @

	update: () =>

		return

	onPlayerTouch: () =>
		console.log 'you hit the switch'
		_.each @targets, (target) =>
			target.deactivate()
		return

module.exports = Switch
