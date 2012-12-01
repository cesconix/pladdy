module.exports.not_found = (req, res) ->
	res.status 404
	res.render 'pages/404', title : '404 Not Found'

module.exports.home = (req, res) ->
	res.render 'pages/home', title : 'Developers'

module.exports.endpoints = (req, res) ->
	res.render 'pages/endpoints', title : 'API Endpoints'
