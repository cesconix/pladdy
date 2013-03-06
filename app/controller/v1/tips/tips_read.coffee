#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api}           = require "#{paths.CONTROLLER}/common/component"
{compactObject} = require "#{paths.CONTROLLER}/common/helpers"

_js   = require 'underscore'

module.exports =

class TipsRead extends Api

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
		PlaceModel    = db.model 'Place'
		TipModel      = db.model 'Tip'

		PlaceModel.findOne { _id : @data.place_id }, (err, place) =>

			if not place?
				return Response.endpoint_error res, 'place not found'

			where = {}

			if @data.page_time?
				switch @data.page_type
					when 'new'
						where = { _id : { $in : place.tips }, created : { $gt : new Date( Number @data.page_time ) } }
					when 'old'
						where = { _id : { $in : place.tips }, created : { $lt : new Date( Number @data.page_time ) } }

			TipModel
			.find(where)
			.sort({ created : 'desc' })
			.limit(Number @data.page_size)
			.exec (err, tips) =>
				if err?
					Logger.error err

				if tips.length is Number @data.page_size
					tip  = if @data.page_type is 'new' then _js.first(tips) else _js.last(tips)
					page_time  = "page_time=#{tip.created.getTime()}&"
					page_size  = "page_size=#{@data.page_size}&"
					page_type  = "page_type=#{@data.page_type}&"
					pagination = { next_url : "/v#{req.params.ver}/places/#{@data.place_id}/tips?#{page_type}#{page_size}#{page_time}access_token=#{@data.access_token}" }
				else
					pagination = null

				compactTips = []
				for tip in tips
					compactTips.push compactObject('tip', tip).object

				return Response.ok res, compactTips, pagination


