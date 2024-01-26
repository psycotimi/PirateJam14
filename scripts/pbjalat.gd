extends Sprite2D


var shufflespeed = 3*PI
var phase: float
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if global_position.x > 400 && -5 < rotation_degrees && rotation_degrees < 5:
        rotation_degrees = 0
        set_script(null)
    else:
        phase += delta
        rotation_degrees = -15*sin(shufflespeed*phase)
    pass
