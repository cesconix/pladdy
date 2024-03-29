#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{existsSync} = require 'fs'
{vsprintf}   = require 'sprintf'

class L10n

	constructor : ->
		# Default language
		@_defaultLanguage = 'en-us'

		# Localization Catalog
		@_L10nCatalog =
			'it-it' : 'ita'
			'en-us' : 'eng'

		# Locale
		@locale = @_L10nCatalog[ @_defaultLanguage ]

	init : ->
		(req, res, next) =>
			@setLocale req.acceptedLanguages[0]
			next()

	setLocale : (lang) =>
		@locale = if lang then @_L10nCatalog[ lang.toLowerCase() ] else @_L10nCatalog[ @_defaultLanguage ]

	__ : (string, args = []) =>
		pathname = "#{paths.LOCALE}/#{@locale}"

		# Check String
		if existsSync pathname
			locale = require pathname
			string = locale[string] if locale[string]

		vsprintf string, args

module.exports = new L10n
