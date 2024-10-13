extends Node

var tcp := StreamPeerTCP.new()
var connected = false

enum DataType {
	Position,
	Texture,
	GameData
}

func _ready():
	var args = Array(OS.get_cmdline_args())
	if args.has("-s"): set_process(false)
	tcp.connect_to_host("127.0.0.1", 4242)
	#tcp.connect_to_host("147.185.221.23", 18085)

func _process(delta):
	tcp.poll()
	var availableBytes: int = tcp.get_available_bytes()
	if availableBytes > 0:
		var data = tcp.get_data(availableBytes)
		if data[0] == OK: recievedData(data[1])

signal recievedTexture(textureName, texture)
signal recievedGameData(dataName, data)
func recievedData(packet):
	connected = true
	var data = bytes_to_var(packet)
	if not data: return
	match data[0]:
		DataType.Texture:
			var texture
			if not data[2]: texture = getLocalTexture(data[1])
			else:
				var image: Image = Image.new()
				image.load_png_from_buffer(data[2])
				texture = ImageTexture.create_from_image(image)
			recievedTexture.emit(data[1], texture)
		DataType.GameData: recievedGameData.emit(data[1], data[2])
			
func requestTexture(textureName: String):
	request([DataType.Texture, textureName])
	var texture = await recievedTexture
	while !texture[0] == textureName: texture = await recievedTexture
	return texture[1]
func requestGameData(data: String):
	request([DataType.GameData, data])
	var gamedata = await recievedGameData
	while !gamedata[0] == data: gamedata = await recievedGameData
	return gamedata[1]

func request(data: Array):
	while !tcp.get_status() == StreamPeerTCP.STATUS_CONNECTED: await get_tree().process_frame
	tcp.put_data(var_to_bytes(data))

var battleIcons: CompressedTexture2D = preload("res://Art/UI_art/Icons/battle_icons.png")
func getLocalTexture(textureName: String):
	match textureName:
		"attack":
			var atlasTexture: AtlasTexture = AtlasTexture.new()
			atlasTexture.atlas = battleIcons
			atlasTexture.region = Rect2(0,0,64,64)
			return atlasTexture
		"act":
			var atlasTexture: AtlasTexture = AtlasTexture.new()
			atlasTexture.atlas = battleIcons
			atlasTexture.region = Rect2(64,0,64,64)
			return atlasTexture
		"item":
			var atlasTexture: AtlasTexture = AtlasTexture.new()
			atlasTexture.atlas = battleIcons
			atlasTexture.region = Rect2(192,0,64,64)
			return atlasTexture
		"defend":
			var atlasTexture: AtlasTexture = AtlasTexture.new()
			atlasTexture.atlas = battleIcons
			atlasTexture.region = Rect2(320,0,64,64)
			return atlasTexture
