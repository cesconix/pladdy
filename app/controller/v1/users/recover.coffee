{Api, Email} = require "#{paths.CONTROLLER}/common/component"
{check}      = require 'validator'
crypto       = require 'crypto'

module.exports =

class Recover extends Api

	constructor: ->
		super
		@params = params

	#
	# API Params
	#
	params =

		username_or_email:
			required : yes

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		UserModel    = db.model 'User'
		SessionModel = db.model 'Session'

		# is an email address
		try
			check(@data.username_or_email).isEmail()
			where = email : @data.username_or_email

		# is an username
		catch e
			where = username : @data.username_or_email

		# recover
		UserModel.findOne where, (err, user_result) ->
			if user_result?
				if user_result.email_confirmed is no
					return Response.other res, "email not confirmed", __('Is not possible send a mail for password reset to \'%s\' because the email address was not confirmed yet', [user_result.email])

				# create hash expiry (1 hr)
				now = new Date()
				hash_expiry = crypto
								.createHmac('sha1', app.get 'security salt')
								.update( user_result.email + now.getFullYear().toString() + now.getMonth().toString() + now.getDay().toString() + now.getHours().toString())
								.digest('hex')

				#
				# Send Email
				#
				options =
					template : "recover"
					to       : "#{user_result.username} <#{user_result.email}>"
					subject  : __('Dimenticato la password, %s?', [user_result.username])

				data =
					title : options.subject
					name  : user_result.username
					link  : app.get('server website') + "v1/users/password_reset/#{user_result.hash}/#{hash_expiry}"

				email = new Email(options, data)

				email.send (err) ->
					Logger.err(err) if err?

				return Response.ok res, {}

			else
				return Response.param_error res, "must provide a valid username or email", __('User not found')
