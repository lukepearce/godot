extends Node

@onready var tilemap = $TileMap

func _ready():
	setup_tileset()

func setup_tileset():
	# Create a new TileSet
	var tileset = TileSet.new()
	
	# Load the texture
	var texture = load("res://assets/kenney_hexagon-buildings/Spritesheet/sheet.xml")
	
	# Add the texture to the TileSet
	var source_id = tileset.add_source(texture, 0)
	var source = tileset.get_source(source_id)
	
	# Set up hexagon tile shape
	source.set_tile_shape(TileSetAtlasSource.SHAPE_HEXAGON)
	source.set_texture_region_size(Vector2i(65, 89))
	
	# Parse the XML file
	var xml_file = FileAccess.open("res://sheet.xml", FileAccess.READ)
	var xml_content = xml_file.get_as_text()
	var xml = XMLParser.new()
	
	if xml.open_buffer(xml_content.to_utf8_buffer()) == OK:
		while xml.read() == OK:
			if xml.get_node_type() == XMLParser.NODE_ELEMENT and xml.get_node_name() == "SubTexture":
				var name = xml.get_named_attribute_value("name")
				var x = int(xml.get_named_attribute_value("x"))
				var y = int(xml.get_named_attribute_value("y"))
				var width = int(xml.get_named_attribute_value("width"))
				var height = int(xml.get_named_attribute_value("height"))
				
				# Create a tile for each sprite
				var tile_id = source.add_tile(Vector2i(x, y), Vector2i(width, height))
				
				# Set tile properties based on the name
				var properties = {}
				if "Roof" in name:
					properties["type"] = "roof"
				elif "Window" in name:
					properties["type"] = "window"
				elif "Door" in name:
					properties["type"] = "door"
				elif "Gate" in name:
					properties["type"] = "gate"
				
				# Add material type
				if "wood" in name.to_lower():
					properties["material"] = "wood"
				elif "stone" in name.to_lower():
					properties["material"] = "stone"
				elif "sand" in name.to_lower():
					properties["material"] = "sand"
				elif "red" in name.to_lower():
					properties["material"] = "red"
				
				# Set the properties for the tile
				for prop_name in properties:
					source.set_tile_meta(tile_id, prop_name, properties[prop_name])
	
	# Apply the TileSet to the TileMap
	tilemap.tile_set = tileset
	
	# Set up the TileMap for hexagon grid
	tilemap.set_cell_size(Vector2i(65, 89))
	tilemap.set_tile_shape(TileMap.TILE_SHAPE_HEXAGON)
