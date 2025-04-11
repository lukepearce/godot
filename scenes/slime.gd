extends CharacterBody2D

const SPEED = 50
var direction = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Connect area signals
    $DetectionArea.body_entered.connect(_on_body_entered)
    $DetectionArea.body_exited.connect(_on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    velocity.y = SPEED * direction
    move_and_slide()

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        print("Player entered slime area!")

func _on_body_exited(body: Node2D) -> void:
    if body.is_in_group("player"):
        print("Player left slime area!")
