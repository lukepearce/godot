extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  print("Door ready")
  print("Door collision layer: ", collision_layer)
  print("Door collision mask: ", collision_mask)
  print("Door monitoring: ", monitoring)
  print("Door monitorable: ", monitorable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _on_area_entered(area: Area2D) -> void:
  print("Area entered: ", area.name)


func _on_area_exited(area: Area2D) -> void:
  print("Area exited: ", area.name)


func _on_body_entered(body: Node2D) -> void:
  print("Body entered: ", body.name)
  print("Body type: ", body.get_class())


func _on_body_exited(body: Node2D) -> void:
  print("Body exited: ", body.name)
  print("Body type: ", body.get_class())
