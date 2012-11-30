class Response

	constructor : ->

		successTypes =

			#Success
			ok             : 200
			created        : 201

		errorTypes =

			# Client Error
			param_error    : 400
			invalid_auth   : 401
			endpoint_error : 404
			not_authorized : 403
			other          : 405

			# Server Error
			server_error   : 500

		successExec = (code) ->
			(res, data = {}, layout = 'default') ->
				res.send code, @response(code, data, null, layout)

		errorExec = (type, code) ->
			(res, details, message, layout = 'default') ->
				error         = {}
				error.type    = type
				error.details = details
				error.message = message if message?
				res.send code, @response(code, {}, error, layout)

		for type, code of successTypes
			@[type] = successExec code

		for type, code of errorTypes
			@[type] = errorExec type, code

		@exec = @response

	response : (code, data, error, layout = 'default') ->
		(require "#{paths.VIEW}/layouts/responses/#{layout}") code, data, error

module.exports = new Response
