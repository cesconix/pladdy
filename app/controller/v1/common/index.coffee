response = require "#{PATHS.LIB}/response"

module.exports.endpoint_error = (req, res) ->
	res.send(response.endpoint_error('Endpoint not found'))

module.exports.index = (req, res) ->
	res.send 'Welcome to Pladdy API v1'
