{Api}  = require "#{paths.CONTROLLER}/common/component"

module.exports =

class ProfileUpdate extends Api

	constructor: ->
		super

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		return Response.ok res, res.locals.user
