#----------------
# EMAIL
#----------------

class Email

	constructor: (@options, @data = {}) ->

	getTransport : ->
		transport = app.get('email').transport
		require('nodemailer').createTransport transport.type, transport.options

	send : (cb) ->
		html = text = ''

		app.render "#{paths.VIEW}/email/html/#{@options.template}", @data, (err, html) =>
			html = if err then err else html

			app.render "#{paths.VIEW}/email/text/#{@options.template}", @data, (err, text) =>
				text = if err then err else text

				message =
					from                 : "#{app.get('app title')} <noreply@pladdy.com>"
					to                   : @options.to
					subject              : @options.subject
					html                 : html
					generateTextFromHTML : on

				@getTransport().sendMail message, cb

module.exports.Email = Email

#----------------
# API
#----------------

class Api

	data   : {}

	check_params: =>
		return false if not @params?

		for param, options of @params
			if options.required and not @req.body[param]?
				return Response.param_error @res, "missing '#{param}' parameter"
			@data[param] = @req.body[param]

		return false

	exec: (req, res) =>
		@req = req
		@res = res
		return false if @check_params() isnt false

module.exports.Api = Api
