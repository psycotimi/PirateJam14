extends TileMap

var gridSize = Global.gridsize
var tiles = {}
var prevtile = Vector2i(0,0)
var troopLabel = Label.new()


# Called when the node enters the scene tree for the first time.
func _ready():
    for x in range(23, gridSize+23):
        for y in range(12, gridSize+12):
            troopLabel.position = Vector2(x,y)

            # näistä pitää poistaa gridin ulkopuoliset ruudut
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
<<<<<<< HEAD
            tiles[str(Vector2(x,y))] = {
                "surface" : Global.spreadTypeList[1], # aluksi hilloton
=======
            tiles[Vector2(x,y)] = {
                "spread" : Global.spreadTypeList[2], # aluksi hilloton
>>>>>>> 757304514dd2393aad0a91c26db393372f428029
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
            
<<<<<<< HEAD
    if tiles.has(str(tile)):
        print(tile)
=======
    if tiles.has(tile):
>>>>>>> 757304514dd2393aad0a91c26db393372f428029
        set_cell(1, tile, 1, Vector2i(0,0), 0)

func update_grafiikkatilet():
  for tile in tiles:
    $grafiikkatilet.setSpread(tile.grafiikkatilet,tile.spread)
