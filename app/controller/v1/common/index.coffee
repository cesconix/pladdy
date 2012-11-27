response = require "#{paths.LIB}/response"

module.exports.endpoint_error = (req, res) ->
	res.send response.endpoint_error('Endpoint not found')
