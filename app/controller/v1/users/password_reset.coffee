#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api, Email} = require "#{paths.CONTROLLER}/common/component"
crypto       = require 'crypto'

module.exports =

class PasswordReset extends Api

	constructor: ->
		super
		@params = params

	#
	# API Params
	#
	params =
		body:
			new_password : { required : yes }

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		UserModel    = db.model 'User'
		SessionModel = db.model 'Session'

		UserModel.findOne { hash : @data.hash_user }, (err, user_result) =>

			# user not found
			if not user_result?
				return Response.endpoint_error res, 'endpoint not found'

			# verify if hash_expiry is valid
			now = new Date()
			hash_expiry = crypto
							.createHmac('sha1', app.get 'security salt')
							.update( user_result.email + now.getFullYear().toString() + now.getMonth().toString() + now.getDay().toString() + now.getHours().toString())
							.digest('hex')

			# sorry, link expired
			if hash_expiry isnt @data.hash_expiry
				return Response.endpoint_unavailable res, 'hash expired (querystring) or not valid', __('Sorry! Link expired or not valid, try to send another link for password reset and be sure to reply faster!')

			# change password
			user_result.password = @data.new_password
			user_result.hash     = crypto
										.createHmac('sha1', app.get 'security salt')
										.update( user_result.username + Math.round(new Date().getTime()).toString() )
										.digest('hex')

			user_result.save (err, user_result) ->
				if err?
					return Response.validation_error err, res

				# check if there are active login for this user and request user-agent
				SessionModel.findOne { user_id : user_result._id, user_agent : req.headers['user-agent'], logout_time : null }, (err, session_result) ->

					# session found
					if session_result?
						return Response.ok res, { access_token : session_result.access_token, last_login : session_result.last_login }

						# update last login
						SessionModel.update { access_token : session_result.access_token }, { last_login : new Date }

					# session not found
					else
						session = new SessionModel
						session.user_id      = user_result._id
						session.user_agent   = req.headers['user-agent']
						session.access_token = crypto
													.createHmac('sha1', app.get 'security salt')
													.update( user_result._id + Math.round(new Date().getTime()).toString() )
													.digest('hex')

						# save session
						session.save (err, session_saved) ->
							if err?
								return Response.validation_error err, res
							return Response.created res, access_token : session_saved.access_token
