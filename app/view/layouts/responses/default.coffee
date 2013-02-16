module.exports = (code, data, pagination, notifications, error) ->

	response =
		meta :
			code : code

	if data isnt null
		response.data = data

	if pagination isnt null
		response.pagination = pagination

	if notifications isnt null
		response.notifications = notifications

	if error isnt null
		response.meta.errorType    = error.type
		response.meta.errorDetail  = error.details
		response.meta.errorMessage = error.message if error.message isnt ''

	response
