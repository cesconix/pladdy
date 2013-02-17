#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api}  = require "#{paths.CONTROLLER}/common/component"
crypto = require 'crypto'

module.exports =

class Login extends Api

	constructor: ->
		super
		@params = params

	#
	# API Params
	#
	params =
		body:
			username  { required : yes }
			password : { required : yes }

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		UserModel    = db.model 'User'
		SessionModel = db.model 'Session'

		# encrypt password
		password = crypto
						.createHmac('sha1', app.get 'security salt')
						.update(@data.password)
						.digest('hex')

		UserModel
		.findOne()
		.or([ { username : @data.username, password : password } ])
		.or([ { email    : @data.username, password : password, email_confirmed : yes } ])
		.exec (err, user_result) ->

			# user found
			if user_result?

				# check if there are active login for this user and request user-agent
				SessionModel.findOne { user_id : user_result._id, user_agent : req.headers['user-agent'], logout_time : null }, (err, session_result) ->

					# session found
					if session_result?
						# update last login
						SessionModel.update { access_token : session_result.access_token }, { last_login : new Date }

						return Response.ok res, { access_token : session_result.access_token, last_login : session_result.last_login }

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

			#user not found
			else
				return Response.invalid_auth res, 'user not found or invalid password', __('wrong username or password')
