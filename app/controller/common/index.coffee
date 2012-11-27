response = require "#{paths.LIB}/response"

module.exports.page_not_found = (req, res) ->
	res.send 404

module.exports.home = (req, res) ->
	res.render 'pages/home', title : 'Developers'

module.exports.endpoints = (req, res) ->
	res.render 'pages/endpoints', title : 'API Endpoints'
