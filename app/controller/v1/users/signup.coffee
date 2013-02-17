#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api, Email} = require "#{paths.CONTROLLER}/common/component"
crypto       = require 'crypto'

module.exports =

class Signup extends Api

	constructor: ->
		super
		@params = params

	#
	# API Params
	#
	params =
		body:
			username : { required : yes }
			email    : { required : yes }
			password : { required : yes }

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		UserModel    = db.model 'User'
		SessionModel = db.model 'Session'

		# check if the username or email already exists
		UserModel.findOne().select('username email').or([ {username : @data.username}, {email : @data.email} ]).exec (err, results) =>
			if results?
				key = if @data.username is results.username then @data.username else @data.email
				return Response.already_exists res, "duplicate key: #{key}", __('The specified user already exists')

			# user
			user = new UserModel
			user.username = @data.username
			user.email    = @data.email
			user.password = @data.password
			user.hash     = crypto
								.createHmac('sha1', app.get 'security salt')
								.update( @data.username + Math.round(new Date().getTime()).toString() )
								.digest('hex')

			# save user
			user.save (err, user_result) =>
				if err?
					return Response.validation_error err, res

				# session
				session = new SessionModel
				session.user_id      = user_result._id
				session.user_agent   = req.headers['user-agent']
				session.access_token = crypto
											.createHmac('sha1', app.get 'security salt')
											.update( user_result._id + Math.round(new Date().getTime()).toString() )
											.digest('hex')

				# save session
				session.save (err, session_result) ->
					if err?
						return Response.validation_error err, res

					#
					# Send Email
					#
					options =
						template : 'signup'
						to       : "#{user_result.username} <#{user_result.email}>"
						subject  : __('Conferma la tua email %s, %s!', [app.get('app title'), user_result.username])

					data =
						title : options.subject
						name  : user_result.username
						link  : app.get('server website') + "account/confirm/#{user_result.hash}"

					email = new Email(options, data)

					email.send (err) ->
						Logger.err(err) if err?

					return Response.created res,
						_id             : user_result._id
						username        : user_result.username
						email           : user_result.email
						access_token    : session_result.access_token
