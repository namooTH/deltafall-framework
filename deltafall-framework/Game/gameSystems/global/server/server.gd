extends Node

var server := UDPServer.new()
var peers = []

enum DataType {
	Position,
	Texture,
	GameData
}
	
func _ready():
	server.listen(4242)
	
var actions = ["defend", "act"]
func _process(delta):
	server.poll()
	if server.is_connection_available():
		var peer: PacketPeerUDP = server.take_connection()
		var packet = peer.get_packet()
		peer.put_packet(packet)
		peers.append(peer)

	for peer in peers:
		var packet = peer.get_packet()
		if not packet: continue
		
		var data = bytes_to_var(packet)
		var dataToSend
		if data:
			var dataType = int(data[0])
			match dataType:
				DataType.Texture:
					var image: Image = Image.new()
					image.load("res://Art/my_pfp.png")
					image.generate_mipmaps()
					dataToSend = image.save_png_to_buffer()
					#image.load_png_from_buffer(packet)
					#$Node.texture = ImageTexture.create_from_image(image)
				DataType.GameData:
					# [datatype, area]
					match data[1]:
						"battleSelection":
							dataToSend = actions
			peer.put_packet(var_to_bytes([dataType, dataToSend]))
