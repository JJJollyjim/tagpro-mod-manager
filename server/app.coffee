# External module dependencies
mongoose = require "mongoose"
express  = require "express"
http     = require "http"
path     = require "path"

# Internal module dependencies
utils  = require "./utils" # Utils must come first, as some module loaders need it

models = require "./models"
routes = require "./routes"

#### SCRATCHPAD ####
#                  #

#                  #
####################

# Get express object
app = express()

# Basic setup
app.set "port", process.env.PORT or 3000
app.set "views", "#{__dirname}/views"

# Allow CORS
app.use (req, res, next) ->
	res.header("Access-Control-Allow-Origin", "*")
	res.header("Access-Control-Allow-Headers", "X-Requested-With")
	next()

# Middleware
app.use express.favicon()
app.use express.logger "dev"
app.use express.json()
app.use app.router
app.use express.static "#{__dirname}/public"

# if app.get("env") is "development"
app.use express.errorHandler()

# Set up routes
app.get  "/mods",  routes.mods.get
app.post "/mods",  routes.mods.post
app.get  "/files/:id", routes.files

# Check that a mongo connection string is in the ENV
unless process.env.tagpro_mongodb_connection_string?
	console.log "You must specify the environment variable 'tagpro_mongodb_connection_string'"
	process.exit 1

# Connect to mongo server
mongoose.connect process.env.tagpro_mongodb_connection_string

# Connect to dropbox
new utils.Filestore (err, fs) ->
	if err then throw new Error "Couldn't connect to Filestore"
	console.log "Successfully connected to filestore"

	global.filestore = fs

	mongoose.connection.on "connected", ->
		# Mongo connection succeeded
		console.log "Successfully connected to mongodb server"

		# Start the HTTP server
		http.createServer(app).listen app.get("port"), ->
			console.log "Running Express HTTP server on port #{app.get "port"}"

mongoose.connection.on "disconnected", ->
	# Mongo connection failed
	console.log "Error connecting to mongodb server"
	process.exit 2
