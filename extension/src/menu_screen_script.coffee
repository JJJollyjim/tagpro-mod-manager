console.log "Sent"
chrome.runtime.sendMessage {testMessage: "test"}, (res) ->
	console.log "Received"
	console.log res