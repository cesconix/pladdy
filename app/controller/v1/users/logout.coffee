{Api}  = require "#{paths.CONTROLLER}/common/component"
crypto = require 'crypto'

module.exports =

class Logout extends Api

	constructor: ->
		super

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		SessionModel = db.model 'Session'

		SessionModel.findOneAndUpdate { access_token : req.query.access_token, logout_time : null }, { logout_time : new Date }, (err, session_result) ->
			return Response.no_content res
