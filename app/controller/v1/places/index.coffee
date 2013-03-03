#----------------
# Places
#----------------

[
	  'place_create'
	, 'place_read'

].map (api) ->
	module.exports[api] = (req, res) ->
		Api = new (require "./#{api}")
		Api.exec req, res
