extends Node

enum Direction{
	North,
	South,
	West,
	East
} 

const TILE_SIZE := 32
const HALF_TILE_SIZE := TILE_SIZE / 2
const MAP_WIDTH = 100
const MAP_HEIGHT = 100

const grh_defs:Dictionary = {}

enum Classes{
	Paladin,
	Mage,
	Warrior,
	Druid,
	Bard,
	Hunter,
	Assassin,
	Cleric, 
}

enum Races{
	Human,
	Elf,
	Drown,
	Gnome,
	Dwarf
}

enum ServerPacketID {
	Logged,
	MyCharacter,
	CharacterCreate,
	MoveCharacter,
	DestroyCharacter,
	ChangeDirection,
	ChatMessage,
	ChatConsole,
	SwitchMap,
	RenderItem,
	RemoveArea
}

enum ClientPacketID {
	Login,
	Register,
	ChangeDirection,
	Talk,
	Attack,
	CastSpell,
	Ok,
	Walk
}

const NameClasses = {
	Classes.Paladin : "Paladin",
	Classes.Mage : "Mago",
	Classes.Warrior : "Guerrero",
	Classes.Druid : "Druida",
	Classes.Bard : "Bardo",
	Classes.Hunter : "Cazador",
	Classes.Assassin : "Asesino",
	Classes.Cleric : "Clerigo"
}

const NameRaces = {
	Races.Human : "Humano",
	Races.Elf : "Elfo",
	Races.Drown : "Elfo Oscuro",
	Races.Gnome : "Gnomo",
	Races.Dwarf : "Enano"
}


func _ready():
	_load_grh_data()
	
func _load_grh_data():
	var file = File.new()
	file.open("res://assets/legacy/init/graficos.json", File.READ) 
	
	var content = file.get_buffer(file.get_len())
	var buffer = StreamPeerBuffer.new()
	buffer.data_array = content
	
	buffer.get_data(10 + 255 + 8)
	
	while(buffer.get_position() < buffer.get_size()):
		var grh_id = buffer.get_16()
		grh_defs[grh_id] = {}
		
		grh_defs[grh_id].num_frames = buffer.get_16()
		grh_defs[grh_id].frames = []
		grh_defs[grh_id].frames.resize(grh_defs[grh_id].num_frames + 1)
		
		if grh_defs[grh_id].num_frames > 1:
			for i in range(1, grh_defs[grh_id].num_frames + 1):
				grh_defs[grh_id].frames[i] = buffer.get_16()
				
			grh_defs[grh_id].speed = buffer.get_16()
		else:
			grh_defs[grh_id].file_num = buffer.get_16()
			grh_defs[grh_id].frames[1] = grh_id
			
			var region = Rect2(0, 0, 0, 0)
			region.position.x = buffer.get_16()
			region.position.y = buffer.get_16()
			
			region.size.x = buffer.get_16()
			region.size.y = buffer.get_16()
			 
			grh_defs[grh_id].region = region  
