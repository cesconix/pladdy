{Api}  = require "#{paths.CONTROLLER}/common/component"
crypto = require 'crypto'

class Logout extends Api

	#
	# Exec
	#
	exec: (req, res) ->
		return if super is false

		# Models
		SessionModel = db.model 'Session'

		SessionModel.findOneAndUpdate { access_token : req.query.access_token, logout_time : null }, { logout_time : new Date }, (err, session_result) ->
			return Response.ok res, {}

module.exports = new Logout
