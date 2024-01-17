extends TileMap

var gridSize = 16
var tiles = {}
var prevtile = Vector2i(0,0)
var troopLabel = Label.new()


# Called when the node enters the scene tree for the first time.
func _ready():
    for x in range(23, gridSize+23):
        for y in range(12, gridSize+12):
            troopLabel.position = Vector2(x,y)
            var legalMoves = [
                Vector2(x+1,y),
                Vector2(x-1,y),
                Vector2(x,y+1),
                Vector2(x,y-1)
                ]
            var grafiikkatilet = [
                Vector2(2*x,2*y),
                Vector2(2*x,2*y+1),
                Vector2(2*x+1,2*y),
                Vector2(2*x+1,2*y+1)
                ]
            tiles[str(Vector2(x,y))] = {
                "surface" : Global.spreadTypeList[1], # aluksi hilloton
                "troops" : 0, # joukkojen lukumäärä tilellä, ehkä pitää siirtää alueeseen sitku semmonen on
                "areaid" : 0, # tätä voi käyttää myöhemmin
                "grafiikkatilet" : grafiikkatilet,
                "legalmoves" : legalMoves
            }
            set_cell(0, Vector2(x,y), 0, Vector2(0,0),0)
    # print(tiles) #Testi, että dictionary tulostuu oikein

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var tile = local_to_map(get_global_mouse_position())
    
    for x in range(23, gridSize+23):
        for y in range(12, gridSize+12):
           erase_cell(1, Vector2(x,y))
            
    if tiles.has(str(tile)):
        print(tile)
        set_cell(1, tile, 1, Vector2i(0,0), 0)
