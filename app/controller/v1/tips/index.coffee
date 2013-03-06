#----------------
# Places
#----------------

[
	  'tips_read'
	, 'tip_create'
	, 'tip_read'
	, 'tip_update'
	, 'tip_delete'

].map (api) ->
	module.exports[api] = (req, res) ->
		Api = new (require "./#{api}")
		Api.exec req, res
