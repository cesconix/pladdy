module.exports = (req, res) ->

	User = db.model 'User'

	Core.Response.ok res, {}
