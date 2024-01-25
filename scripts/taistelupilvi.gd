extends Sprite2D

var shufflespeed = 5*PI
var phase: float
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    phase += delta
    rotation_degrees = -40*sin(shufflespeed*phase)
    pass
