chrome.tabs.onUpdated.addListener (tabID, delta, tab) ->
	parser = document.createElement "a"
	parser.href = tab.url

	# Check if we're on a tagpro page
	if /^tagpro[a-z\-]*.koalabeast.com$/.test parser.hostname
		# Show the flag page action
		chrome.pageAction.show tabID

chrome.runtime.onMessage.addListener (req, sender, respond) ->
	respond "Received message!"