module.exports = (code, data, pagination, notifications, error) ->

	response =
		meta :
			code : code

	if data?
		response.data = data

	if pagination?
		response.pagination = pagination

	if notifications?
		response.notifications = notifications

	if error?
		response.meta.errorType    = error.type
		response.meta.errorDetail  = error.details
		response.meta.errorMessage = error.message if error.message isnt ''

	response
