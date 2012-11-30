module.exports.endpoint_error = (req, res) ->
	res.send Core.Response.endpoint_error('Endpoint not found')

module.exports.not_found = (req, res) ->
	res.render 'pages/404', title : '404 Not Found'
