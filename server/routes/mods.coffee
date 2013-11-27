# Dependencies
nodemailer = require "nodemailer"
mongoose   = require "mongoose"

# Email setup
mail_transport = nodemailer.createTransport "Direct", {}
admin_emails = [
	"jamie@kwiius.com"
]

# Import schemas
Mod = mongoose.models.Mod

module.exports = {}

module.exports.get = (req, res) ->
	Mod.find {accepted: true}, "name author", (err, results) ->

		throw new Error("Error loading mod list") if err
		res.status(204) if results.length is 0 # HTTP 202: No content
		res.json results

last_post = {}

module.exports.post = (req, res) ->
	# Request format (JSON):
	# All required!
	# 
	# name: "Any String" (unique)
	# author: "Reddit username"
	# description: "__Markdown__"
	# reddit: "1rbcho" (The ID from the Reddit URL)
	
	unless req.body.name? and req.body.author? and req.body.reddit? and req.body.files.tiles?
		res.status 400
		res.json
			error: "You didn't submit all required fields"

	# Validate that all files are base64 png data URIs
	for name, file in req.body.files
		if /^data:image\/png;base64,/.test(file)
			console.log "#{name} matches regex"
		else
			console.log "#{name} doesn't match regex!"

	if last_post[req.ip]?
		time = last_post[req.ip]

		# Dev number, 5 seconds. Should be more 10 minutes
		if new Date().getTime() - time.getTime() < ( 5 * 1000 )
			res.status 429
			res.json
				error: "You can't submit multiple mods within 10 minutes"
			return

	# All good!
	last_post[req.ip] = new Date()

	mod = new Mod
		name: req.body.name
		author: req.body.author
		reddit: req.body.reddit
		files: req.body.files

	mod.save (err) ->
		if (err)
			res.status 500
			res.json error: "Unknown database error occoured"
		else
			res.status 201
			res.json {}

			# Email admins about the new mod
			for k, email of admin_emails
				message =
					from: "TagPro Mod Manager <jamie@kwiius.com>"
					to:   "TPMM Admins <#{email}>"
					subject: "Review mod: #{mod.name}"
					html: """
					<h1>#{mod.name}</h1>
					<h3>By #{mod.author}</h3>
					<p>#{mod.description}</p>
					<p>Reddit: <a href="http://www.reddit.com/r/TagPro/comments/#{mod.reddit}/">#{mod.reddit}</a></p>
					<p>IP address: #{req.ip}</p>
					"""

				mail_transport.sendMail message, (err, response) ->
					if (err)
						console.error "Error emailing admin (#{email}})"
					else
						console.log "Emailed admin #{email} about #{mod.name}"