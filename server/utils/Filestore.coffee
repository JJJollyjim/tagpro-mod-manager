Dropbox = require "dropbox"
url     = require "url"

class Filestore
	constructor: (callback) ->
		authclient = new Dropbox.Client
			key:    process.env.tpmm_db_key
			secret: process.env.tpmm_db_secret
			token:  process.env.tpmm_db_token
			uid:    process.env.tpmm_db_uid

		# If you need to generate credentials, you can use this authdriver:
		# authclient.authDriver new Dropbox.AuthDriver.NodeServer 8912

		authclient.authenticate (err, client) =>
			if err then return callback(err)
			@client = client

			callback false, @

	addMod: (id, callback) ->
		@client.mkdir id, (err, stat) ->
			callback(err)

	addFile: (id, name, buffer, callback)	->
		@client.writeFile "/#{id}/#{name}.png", buffer, (err, stat) ->
			callback(err)

	urlcache = {}

	getFileURLs: (id, callback) ->
		if id of urlcache
			# Might be able to use a cached URL
			expirednum = 0
			for name, url of urlcache[id]
				expirednum++ if url.exiresAt < new Date()

			if expirednum is 0
				return callback false, urlcache[id]
			else
				console.log "A file has expired, get a new URL (#{id})"

		# If it's not in the cache or a file is expired, get new URLs
		@client.readdir "/#{id}", {}, (err, filenames, folderstat, filestats) =>
			if err then return callback(err, [])

			URLs = {}
			URLsNeeded = 0

			for file in filestats
				if file.isFile and file.mimeType is "image/png" # Should always be, but just in case
					URLsNeeded++
					@client.makeUrl file.path, {download: true}, ((file, err, url) ->
						if err then callback err, {}
						URLs[file.name] = url
						URLsNeeded--

						if URLsNeeded is 0
							urlcache[id] = URLs
							callback false, URLs
					).bind(this, file)

module.exports = Filestore

# new Filestore (err, f) ->
# 	if err then throw new Error "Error connecting to dropbox"
# 	f.addMod "id #{Math.random()}", null, (err) ->
# 		if err then throw new Error "Error creating mod folder"
# 		f.getFileURLs "ID123", (err) ->
# 			if err then console.error err; throw new Error "Error reading file URLs"
# 			console.log arguments

# 			f.getFileURLs "ID123", (err) ->
# 				if err then console.error err; throw new Error "Error reading file URLs twice"
# 				console.log arguments