# Set an initial value for the sid
chrome.storage.local.get ["sid", "files"], (vals) ->
	if typeof vals.sid isnt "string"
		chrome.storage.local.set {sid: "vanilla"}, ->
			console.log "Saved default sid"

	if typeof vals.files isnt "object"
		chrome.storage.local.set {files: {}}, ->
			console.log "Saved default files"

# Show flag icon on the right pages
chrome.tabs.onUpdated.addListener (tabID, delta, tab) ->
	parser = document.createElement "a"
	parser.href = tab.url

	# Check if we're on a tagpro page
	if /^tagpro[a-z\-]*.koalabeast.com$/.test parser.hostname
		# Show the flag page action
		chrome.pageAction.show tabID