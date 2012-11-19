response = require "#{PATHS.LIB}/response"

module.exports.page_not_found = (req, res) ->
	res.send 404

module.exports.index = (req, res) ->
	res.render 'pages/home'
