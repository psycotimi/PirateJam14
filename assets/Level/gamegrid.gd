extends TileMap

var gridSize = 32
var tiles = {}
var prevtile = Vector2i(0,0)
var troopLabel = Label.new()


# Called when the node enters the scene tree for the first time.
func _ready():
    for x in gridSize:
        for y in gridSize:
            var troopLabel = Label.new()
            troopLabel.position = Vector2(x,y)
            tiles[str(Vector2(x,y))] = {
                "surface" : Global.spreadTypeList[2], # aluksi hilloton
                "troops" : 0, # joukkojen lukumäärä tilellä, ehkä pitää siirtää alueeseen sitku semmonen on
                "areaid": 0 # tätä voi käyttää myöhemmin
            }
            troopLabel.text = str(tiles[str(Vector2(x,y))].troops)
            set_cell(0, Vector2(x,y), 0, Vector2(0,0),0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var tile = local_to_map(get_global_mouse_position())
    if tile != prevtile:
        prevtile = tile
        if tile in tiles:
            tiles[str(tile)].troops += 1
            if tiles[str(tile)].troops > Global.troopCountMax:
                tiles[str(tile)].troops = Global.troopCountMax
            print(str(tiles[str(tile)].troops))
        
