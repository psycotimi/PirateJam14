extends TileMap

var gridSize = Global.gridsize
var tiles = {}
var prevtile = Vector2i(0,0)
var troopLabel = Label.new()
var offsetX = 23
var offsetY = 12

var selectedTile
var targetTile


# Called when the node enters the scene tree for the first time.
func _ready():
    for x in range(offsetX, gridSize+offsetX):
        for y in range(offsetY, gridSize+offsetY):
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
            tiles[str(Vector2(x,y))] = {
                "spread" : Global.spreadTypeList[0], # aluksi hilloton
                "troops" : 0, # joukkojen lukumäärä tilellä, ehkä pitää siirtää alueeseen sitku semmonen on
                "areaid" : 0, # tätä voi käyttää myöhemmin
                "grafiikkatilet" : grafiikkatilet,
                "legalmoves" : legalMoves
            }
            set_cell(0, Vector2(x,y), -1, Vector2(-1,-1),0)
    # print(tiles) #Testi, että dictionary tulostuu oikein

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    var tile = local_to_map(get_global_mouse_position())
    
    for x in range(offsetX, gridSize+offsetX):
        for y in range(offsetY, gridSize+offsetY):
           erase_cell(1, Vector2(x,y))
            
    if tiles.has(str(tile)):
        set_cell(1, tile, 1, Vector2i(0,0), 0)
        

func update_grafiikkatilet():
  for tile in tiles:
    $grafiikkatilet.setSpread(tiles[tile].grafiikkatilet,tiles[tile].spread)

func tile_under_mouse():
  return(str(local_to_map(get_global_mouse_position())))
    
func _input(_event):
    if Input.is_action_just_pressed("select_tile"):
        # update_grafiikkatilet() # ei kuulu ajaa joka framella, täällä testitarkotuksena
        if targetTile != null:
            selectedTile = tile_under_mouse()
            targetTile = null
        elif selectedTile != null:
            targetTile = tile_under_mouse()
        else:
            selectedTile = tile_under_mouse()
        tiles[selectedTile].spread = Global.spreadTypeList[1] # muuttaa hiiren alla olevan tilen hilloa 
        $grafiikkatilet.getSpread(tiles[selectedTile].grafiikkatilet)
        $grafiikkatilet.setSpread(tiles[selectedTile].grafiikkatilet,tiles[selectedTile].spread)
        $grafiikkatilet.getSpread(tiles[selectedTile].grafiikkatilet)
        print(selectedTile, targetTile) 
