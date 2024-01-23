extends Sprite2D


var movementspeed: int = 180
var pos: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if global_position.x < 1470:
        set_script(null)
    else:
        pos.x = delta*movementspeed
        position.x -= pos.x
    pass
