extends Node

@onready var terrain_tilemap = $TerrainTileMap
@onready var decoration_tilemap = $DecorationTileMap

func _ready():
  setup_tilesets()

func setup_tilesets():
  # Create tilesets for different groups
  var terrain_tileset = create_tileset("terrain")
  var decoration_tileset = create_tileset("decoration")
  
  # Apply tilesets
  terrain_tilemap.tile_set = terrain_tileset
  decoration_tilemap.tile_set = decoration_tileset
  
  # Configure tilemaps
  terrain_tilemap.set_cell_size(Vector2i(65, 89))
  terrain_tilemap.set_tile_shape(2) # Hexagon shape
  
  decoration_tilemap.set_cell_size(Vector2i(65, 89))
  decoration_tilemap.set_tile_shape(2) # Hexagon shape

func create_tileset(type: String) -> TileSet:
  var tileset = TileSet.new()
  
  # Load the texture
  var texture = load("res://assets/kenney_hexagon-buildings/Spritesheet/sheet.png")
  
  # Add the texture to the TileSet
  var source_id = tileset.add_source(texture, 0)
  var source = tileset.get_source(source_id)

  # Set up hexagon tile shape
  source.set_tile_shape(2) # 2 is the value for hexagon shape
  
  # Parse the XML file
  var xml_file = FileAccess.open("res://assets/kenney_hexagon-buildings/Spritesheet/sheet.xml", FileAccess.READ)
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
        
        # Filter tiles based on type
        var should_add = false
        if type == "terrain":
          # Add main terrain tiles (65x89)
          should_add = "tile" in name.to_lower() and width == 65 and height == 89
        elif type == "decoration":
          # Add decorative elements (trees, rocks, etc.)
          should_add = ("tree" in name.to_lower() or 
                       "rock" in name.to_lower() or 
                       "bush" in name.to_lower() or 
                       "flower" in name.to_lower())
        
        if should_add:
          # Create a tile
          var tile_id = source.add_tile(Vector2i(x, y), Vector2i(width, height))
          
          # Set tile properties
          var properties = {}
          
          # Categorize terrain types
          if "Autumn" in name: properties["terrain"] = "autumn"
          elif "Dirt" in name: properties["terrain"] = "dirt"
          elif "Grass" in name: properties["terrain"] = "grass"
          elif "Lava" in name: properties["terrain"] = "lava"
          elif "Magic" in name: properties["terrain"] = "magic"
          elif "Rock" in name: properties["terrain"] = "rock"
          elif "Sand" in name: properties["terrain"] = "sand"
          elif "Snow" in name: properties["terrain"] = "snow"
          elif "Stone" in name: properties["terrain"] = "stone"
          elif "Water" in name: properties["terrain"] = "water"
          
          # Add decoration types
          if "tree" in name.to_lower(): properties["type"] = "tree"
          elif "rock" in name.to_lower(): properties["type"] = "rock"
          elif "bush" in name.to_lower(): properties["type"] = "bush"
          elif "flower" in name.to_lower(): properties["type"] = "flower"
          
          # Set the properties for the tile
          for prop_name in properties:
            source.set_tile_meta(tile_id, prop_name, properties[prop_name])
  
  return tileset
