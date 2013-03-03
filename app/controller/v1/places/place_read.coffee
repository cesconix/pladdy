#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api} = require "#{paths.CONTROLLER}/common/component"
_js   = require 'underscore'

module.exports =

class PlaceCreate extends Api

	constructor: ->
		super
		@params = params

	#
	# API Params
	#
	params =
		query:
			lat  : { required : yes }
			lng  : { required : yes }
			type : { required : no, values : ['love', 'vendor'] }

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		PlaceModel    = db.model 'Place'
		ActivityModel = db.model 'Activity'

		where =
			ranking :
				$gte : app.get('app settings').rankPlaceVisibility
			loc :
				$near : [ @data.lat, @data.lng ]

		if @data.type?
			where.type = @data.type

		PlaceModel.find where, (err, results) =>

			if err?
				Logger.error err

			return Response.ok res, results
