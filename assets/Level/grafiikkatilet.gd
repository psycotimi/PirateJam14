extends TileMap

var offsetX = 23*2
var offsetY = 12*2
var gridSize = Global.gridsize*2 
var allTiles = {}
var neighbours = []

# Called when the node enters the scene tree for the first time.
func _ready():
    for x in range(offsetX, offsetX+gridSize):
        for y in range(offsetY,offsetY+gridSize):
            allTiles[str(Vector2(x,y))] = {
                "spread": Global.spreadTypeList[2]
            }


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
    
func setSpread(tiles,spread):
    set_cells_terrain_connect(0, tiles,0, Global.spreadTypeList.find(spread,0), true)
    
    
