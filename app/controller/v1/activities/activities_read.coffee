#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api}           = require "#{paths.CONTROLLER}/common/component"
{compactObject} = require "#{paths.CONTROLLER}/common/helpers"

_js   = require 'underscore'
async = require 'async'

module.exports =

class ActivitiesRead extends Api

	constructor: ->
		super
		@params = params

	#
	# API Params
	#
	params =
		query:
			page_type : { required : no, values : ['new', 'old'], default  : 'old' }
			page_size : { required : yes }
			page_time : { required : no  }

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		ActivityModel = db.model 'Activity'
		PlaceModel    = db.model 'Place'
		UserModel     = db.model 'User'

		where = {}

		if @data.page_time?
			switch @data.page_type
				when 'new'
					where = { created : { $gt : new Date( Number @data.page_time ) } }
				when 'old'
					where = { created : { $lt : new Date( Number @data.page_time ) } }

		ActivityModel
		.find(where)
		.sort({ created : 'desc' })
		.limit(Number @data.page_size)
		.exec (err, activities) =>

			if activities.length is 0
				return Response.ok res, activities

			getModel = (type) ->
				switch type
					when 'place'
						model = PlaceModel
					when 'user'
						model = UserModel
				return model

			createCallback = (type, model, object) ->
				(cb) ->
					model.findOne { _id : object }, (err, results) ->
						if err?
							return cb err, null

						object =
							type   : type
							object : results

						return cb null, object

			activities_populated = []
			last_activity = _js.last activities

			for activity in activities

				tasks = {}

				# Actor
				tasks.actor  = createCallback(activity.actor.type, getModel(activity.actor.type), activity.actor.object)

				# Object
				tasks.object = createCallback(activity.object.type, getModel(activity.object.type), activity.object.object)

				# Target
				tasks.target = createCallback(activity.target.type, getModel(activity.target.type), activity.target.object)

				# final callback
				aggregateObjects = (err, results) =>
					if err?
						Logger.error err
						return Response.server_error res, 'internal server error'

					results.actor  = compactObject results.actor.type , results.actor.object
					results.object = compactObject results.object.type, results.object.object
					results.target = compactObject results.target.type, results.target.object

					activities_populated.push
						actor   : results.actor
						verb    : activity.verb
						object  : results.object
						target  : results.target
						created : activity.created.getTime()

					if activity._id is last_activity._id

						if activities_populated.length is Number @data.page_size
							activity   = if @data.page_type is 'new' then _js.first(activities_populated) else _js.last(activities_populated)
							page_time  = "page_time=#{activity.created}&"
							page_size  = "page_size=#{@data.page_size}&"
							page_type  = "page_type=#{@data.page_type}&"
							pagination = { next_url : "/v#{req.params.ver}/users/self/activities?#{page_type}#{page_size}#{page_time}access_token=#{@data.access_token}" }
						else
							pagination = null

						return Response.ok res, activities_populated, pagination

				async.parallel tasks, aggregateObjects
