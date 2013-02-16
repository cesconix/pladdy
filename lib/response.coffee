#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

class Response

	constructor : ->

		successTypes =

			#Success
			ok                   : 200
			created              : 201
			no_content           : 204

		errorTypes =

			# Client Error
			param_error          : 400
			#validation_error    : 400
			invalid_auth         : 401
			endpoint_error       : 404
			not_authorized       : 403
			other                : 405
			already_exists       : 409
			endpoint_unavailable : 410

			# Server Error
			server_error         : 500

		successExec = (code) ->
			(res, data, pagination, notifications, layout = 'default') ->
				res.send code, @response(code, data, pagination, notifications, null, layout)

		errorExec = (type, code) ->
			(res, details, message, layout = 'default') ->
				error         = {}
				error.type    = type
				error.details = details
				error.message = message if message?
				res.send code, @response(code, null, null, null, error, layout)

		for type, code of successTypes
			@[type] = successExec code

		for type, code of errorTypes
			@[type] = errorExec type, code

		@exec = @response

	response : (code, data, pagination, notification, error, layout = 'default') ->
		(require "#{paths.VIEW}/layouts/responses/#{layout}") code, data, pagination, notification, error

	validation_error : (err, res, layout = 'default') ->
		if err.name is 'ValidationError'
			errors = {}
			for errorField, errorInfo of err.errors
				errors[errorField] = errorInfo.type
		error         = {}
		error.type    = 'validation_error'
		error.message = errors
		res.send 400, @response(400, null, null, null, error, layout)

module.exports = new Response
