module.exports = (code, data, error) ->

	response =
		meta :
			code : code
		data : data

	if error isnt null
		response.meta.errorType    = error.type
		response.meta.errorDetail  = error.details
		response.meta.errorMessage = error.message if error.message isnt ''

	response
