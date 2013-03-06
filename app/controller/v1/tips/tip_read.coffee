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

class TipRead extends Api

	constructor: ->
		super

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		PlaceModel    = db.model 'Place'
		TipModel      = db.model 'Tip'

		PlaceModel.findOne { _id : @data.place_id, tips : { $in : [@data.tip_id] } }, (err, place) =>

			if not place?
				return Response.endpoint_error res, 'place or tip not found'

			TipModel.findOne { _id : @data.tip_id }, (err, tip) ->
				return Response.ok res, compactObject('tip', tip).object
