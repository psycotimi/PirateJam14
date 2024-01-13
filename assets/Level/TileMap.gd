extends TileMap


var gridSize = 32
var allTiles = {}

# Called when the node enters the scene tree for the first time.
func _ready():
    for x in gridSize:
        for y in gridSize:
            allTiles[str(Vector2(x,y))] = {
                "surface": "bread"
            }
            set_cell(0, Vector2(x,y), 1, Vector2(1,1),0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var tile = local_to_map(get_global_mouse_position())

    if allTiles.has(str(tile)):
        set_cell(0, tile,1,Vector2i(0,0),0)
