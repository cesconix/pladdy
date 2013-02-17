#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

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

		SessionModel.findOneAndUpdate { access_token : @data.access_token, logout_time : null }, { logout_time : new Date }, (err, session_result) ->
			return Response.ok res
