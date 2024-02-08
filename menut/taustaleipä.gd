extends Sprite2D


var sotilasjam = preload("res://assets/graphics/sotilaat/sotilasjam.png")
var sotilaspb = preload("res://assets/graphics/sotilaat/sotilaspb.png")
var tyhjasotilas = preload("res://assets/graphics/sotilaat/tyhjasotilas.png")
var tyhjasotilashyppaa = preload("res://assets/graphics/sotilaat/tyhjasotilashyppaa.png")

var rotation_speed = PI/3
# Called when the node enters the scene tree for the first time.
func _ready():
    var x = randi_range(1,4)
    if x == 1:
        self.set_texture(sotilasjam)
    elif x == 2:
        self.set_texture(sotilaspb)
    elif x == 3:
        self.set_texture(tyhjasotilas)
    elif x == 4:
        self.set_texture(tyhjasotilashyppaa)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    rotation -= rotation_speed*delta
    pass
