extends Node

var server := TCPServer.new()
var streamServer: StreamPeerTCP
var peers = []

enum DataType {
	Position,
	Texture,
	GameData
}
	
func _ready():
	var args = Array(OS.get_cmdline_args())
	if args.has("-s"):
		print("starting server...")
		for node in get_tree().root.get_children(): if !node.name in ["GameSystem", "Server"]: node.queue_free() 
		loadPlugins()
		server.listen(4242)
	
func _process(delta):
	if server.is_connection_available(): peers.append(server.take_connection())
	
	for peer in peers:
		peer.poll()
		if !peer.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			peers.erase(peer)
			continue
		var availableBytes: int = peer.get_available_bytes()
		if availableBytes > 0:
			var data = peer.get_data(availableBytes)
			if data[0] == OK:
				data = bytes_to_var(data[1])
				if data: peer.put_data(processRequest(data))
					
func processRequest(data):
	var dataToSend
	var dataType = int(data[0])
	match dataType:
		DataType.Texture: dataToSend=pluginsCallMethod("textureRequest", [self, data[1]])
		DataType.GameData:
			dataToSend=pluginsCallMethod(data[1], [self])
			if !dataToSend:
				match data[1]:
					"battleSelection": dataToSend = ["attack", "act", "item", "defend"]
	return var_to_bytes([dataType, data[1], dataToSend])
		
var loadedPlugins = []
func loadPlugins():
	DirAccess.make_dir_absolute("user://plugins")
	var plugins = DirAccess.get_files_at("user://plugins")
	for plugin in plugins:
		loadedPlugins.append(load("user://plugins/" + plugin).new())
func pluginsCallMethod(method: String, args: Array):
	for plugin in loadedPlugins:
		var returnedValue
		if plugin.has_method(method): returnedValue = plugin.callv(method, args)
		return returnedValue
