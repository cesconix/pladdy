emailer = require("nodemailer")

class Email

	constructor: (@options, @data = {}) ->

	getTransport : ->
		transport = app.get('email').transport
		emailer.createTransport transport.type, transport.options

	send : (cb) ->
		html = text = ''

		app.render "#{paths.VIEW}/email/html/#{@options.template}", @data, (err, html) =>
			console.log err
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
