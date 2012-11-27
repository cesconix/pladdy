errorTypes =
	param_error    : 400
	invalid_auth   : 401
	endpoint_error : 404
	not_authorized : 403
	server_error   : 500
	other          : 405

response = (code, data, error, layout = 'default') ->
	(require "#{paths.VIEW}/layouts/responses/#{layout}") code, data, error

errorTypeExec = (type, code) ->
	(details, message, layout = 'default') ->
		error         = {}
		error.type    = type
		error.details = details
		error.message = message unless message isnt ''
		response code, {}, error, layout

for type, code of errorTypes
	module.exports[type] = errorTypeExec type, code

module.exports.response = response
