#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

_js = require "underscore"

#----------------
# API
#----------------
#
class Api

	constructor: ->
		@data   = {}
		@params = {}

	check_params: ->
		return false if not @params?

		for type of @params
			for param, options of @params[type]

				@data[param] = @req[type][param]

				# check required
				if options.required? and options.required is yes
					if not @data[param]?
						return Response.param_error @res, "missing '#{param}' (#{type}) parameter"

				if @data[param]?
					# check values
					if options.values? and _js.isArray(options.values)
						if @data[param] not in options.values
							return Response.param_error @res, "'#{param}' param accept only '#{options.values.join '\', \''}'"
				else
					# default value
					if options.default?
						@data[param] = options.default

		return false

	default_params: ->
		# Save access_token
		if @req.query.access_token?
			@data['access_token'] = @req.query.access_token

		if @req.body.access_token?
			@data['access_token'] = @req.body.access_token

		# Add req.params
		for param of @req.params
			@data[param] = @req.params[param]

		delete @data.ver

	exec: (req, res) ->
		@req = req
		@res = res
		return false if @check_params() isnt false
		@default_params()

module.exports.Api = Api


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

