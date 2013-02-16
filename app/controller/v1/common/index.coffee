module.exports.endpoint_error = (req, res) ->
	Response.endpoint_error res, 'endpoint not found'

module.exports.not_found = (req, res) ->
	res.status 404
	res.render 'pages/404', title : '404 Not Found'

module.exports.only_post = (req, res) ->
	Response.other res, 'this endpoint only supports POST'

module.exports.only_get = (req, res) ->
	Response.other res, 'this endpoint only supports GET'
