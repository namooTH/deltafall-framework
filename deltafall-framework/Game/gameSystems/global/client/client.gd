extends Node

var udp := PacketPeerUDP.new()
var connected = false

enum DataType {
	Position,
	Texture,
	GameData
}

func _ready():
	udp.connect_to_host("127.0.0.1", 4242)

func _process(delta):
	if !connected: udp.put_packet(PackedInt32Array([0]).to_byte_array())
	if udp.get_available_packet_count() > 0: recievedPacket(udp.get_packet())
	
signal recievedTexture
signal recievedGameData

func recievedPacket(packet):
	connected = true
	var data = bytes_to_var(packet)
	if not data: return
	match data[0]:
		DataType.Texture:
			var image: Image = Image.new()
			image.load_png_from_buffer(data[1])
			lastTexture = ImageTexture.create_from_image(image)
			recievedTexture.emit()
		DataType.GameData:
			lastGameData = data[1]
			recievedGameData.emit()

var lastTexture	
func requestTexture(textureName: String):
	while !connected: await get_tree().process_frame
	udp.put_packet(var_to_bytes([DataType.Texture, textureName]))
	await recievedTexture
	return lastTexture
var lastGameData
func requestGameData(data: String):
	while !connected: await get_tree().process_frame
	udp.put_packet(var_to_bytes([DataType.GameData, data]))
	await recievedGameData
	return lastGameData
