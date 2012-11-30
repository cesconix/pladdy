module.exports.endpoint_error = (req, res) ->
	Core.Response.endpoint_error res, 'Endpoint not found'

module.exports.not_found = (req, res) ->
	res.render 'pages/404', title : '404 Not Found'
