#----------------
# Places
#----------------

[
	  'place_create'
	, 'place_read'
	, 'like_create'
	, 'like_delete'
	, 'tip_create'
	, 'tip_delete'
	, 'tip_update'
	, 'tip_read'

].map (api) ->
	module.exports[api] = (req, res) ->
		Api = new (require "./#{api}")
		Api.exec req, res
