extends Node2D


var movementspeed: int = 180
var pos: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if global_position.x < 1480:
        set_script("res://scripts/jamilmeet.gd")
    else:
        pos.x = delta*movementspeed
        position.x -= pos.x
    pass
