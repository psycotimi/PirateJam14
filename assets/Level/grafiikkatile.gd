extends TileMap


var gridSize = 32
var allTiles = {}
var neighbours = []

# Called when the node enters the scene tree for the first time.
func _ready():
    for x in gridSize:
        for y in gridSize:
            allTiles[str(Vector2(x,y))] = {
                "surface": Global.spreadTypeList[2]
            }
            set_cell(0, Vector2(x,y), 1, Vector2(1,1),0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var tile = local_to_map(get_global_mouse_position())
    neighbours = generateNeighbours(tile)

    if allTiles.has(str(tile)):
        #set_cells_terrain_connect(0, neighbours,0,true)
        pass

func generateNeighbours(tile):
    var neighbors = []
    for x in range(tile.x-1,tile.x+2):
        for y in range(tile.y-1,tile.y+2):
            if x < 0 or y < 0:
                continue
            elif x > gridSize or y > gridSize:
                continue
            else:
                neighbors.append(Vector2i(x,y))
    return neighbors
    
