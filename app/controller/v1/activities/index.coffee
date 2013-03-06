#----------------
# Activities
#----------------

[
	  'activities_read'

].map (api) ->
	module.exports[api] = (req, res) ->
		Api = new (require "./#{api}")
		Api.exec req, res
