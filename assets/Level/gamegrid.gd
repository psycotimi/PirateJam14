extends TileMap

var gridSize = Global.gridsize
var tiles = {}

var alueet = {}

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

            var grafiikkatilet = [
                Vector2(2*x,2*y),
                Vector2(2*x,2*y+1),
                Vector2(2*x+1,2*y),
                Vector2(2*x+1,2*y+1)
                ]
            tiles[str(Vector2(x,y))] = {
                "spread" : Global.spreadTypeList[0], # aluksi hilloton
                "troops" : 0, # 0-1 solttuleipää
                "areaid" : 0, # tätä voi käyttää myöhemmin
                "grafiikkatilet" : grafiikkatilet,
            }
            set_cell(0, Vector2i(x,y), 0, Vector2i(0,0),0)
    # print(tiles) #Testi, että dictionary tulostuu oikein
    alkupositio()

    var areaid = 0
    var ruutuoffsetx = 0
    for x in range(0,8):
        var ruutuoffsety = 0
        for y in range(0,8):
            areaid += 1
            
            # näistä pitää vielä poistaa gridin ulkopuoliset ruudut
            var legalmoves = [
                Vector2(x+1,y),
                Vector2(x-1,y),
                Vector2(x,y+1),
                Vector2(x,y-1)
                ]
            var ruudut = [
                Vector2(offsetX+x+ruutuoffsetx,offsetY+y+ruutuoffsety),
                Vector2(offsetX+x+ruutuoffsetx,offsetY+y+ruutuoffsety+1),
                Vector2(offsetX+x+ruutuoffsetx+1,offsetY+y+ruutuoffsety),
                Vector2(offsetX+x+ruutuoffsetx+1,offsetY+y+ruutuoffsety+1)
                ]
            alueet[str(Vector2i(x,y))] = {
                "spread" : Global.spreadTypeList[0],
                "troops" : 0, # 0-3 solttuleipää
                "ruudut" : ruudut,
                "legalmoves" : legalmoves,
                "areaid" : areaid
            }
            ruutuoffsety += 1
        ruutuoffsetx += 1
            
     
    for alue in alueet:
        # laillisten siirtojen laillisuuden tarkistus
        for legalmove in alueet[alue].legalmoves:
            if !alueet.has(str(legalmove)):
                #print(legalmove, " pitäisi poistaa")
                # poistetaan gridin ulkopuoliset siirrot laillisista siirroista
                var index = alueet[alue].legalmoves.find(legalmove)
                alueet[alue].legalmoves.erase(legalmove)
        #print(alueet[alue].legalmoves) 
        
        # 
        for ruutu in alueet[alue].ruudut:
            if tiles.has(str(ruutu)):
                tiles[str(ruutu)].areaid = alueet[alue].areaid   
        

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    var tile = local_to_map(get_global_mouse_position())
    var areaid
    for x in range(offsetX, gridSize+offsetX):
        for y in range(offsetY, gridSize+offsetY):
           erase_cell(1, Vector2i(x,y))
            
    if tiles.has(str(tile)):
        areaid = tiles[str(tile)].areaid
        for alue in alueet:
            if alueet[str(alue)].areaid == areaid:
                for ruutu in alueet[str(alue)].ruudut:
                    set_cell(1, Vector2i(ruutu), 1, Vector2i(0,0), 0)
        
# päivittää kaikki tilet
func update_grafiikkatilet():
    for alue in alueet:
        for ruutu in alueet[alue].ruudut:
            tiles[str(ruutu)].spread = alueet[alue].spread
            $grafiikkatilet.setSpread(tiles[str(ruutu)].grafiikkatilet,tiles[str(ruutu)].spread)

func tile_under_mouse():
  return(str(local_to_map(get_global_mouse_position())))
    
func _input(_event):
    if Input.is_action_just_pressed("select_tile"):
        var tile = tile_under_mouse()
        if tiles.has(tile):
            if targetTile != null:
                selectedTile = tile
                targetTile = null
            elif selectedTile != null:
                targetTile = tile
            else:
                selectedTile = tile
            tiles[tile].spread = Global.spreadTypeList[1] # muuttaa hiiren alla olevan tilen hilloa 
            $grafiikkatilet.setSpread(tiles[tile].grafiikkatilet,tiles[tile].spread)
            #update_grafiikkatilet() # ei kuulu ajaa joka framella, täällä testitarkotuksena
            print("selected tile: " + str(selectedTile), " | target tile: " + str(targetTile)) 

func alkupositio(): #muuta tää kutsumaan aluetta, koordinaatit 0:0 - 7:7
    tiles[str(Vector2i(23,12))].spread = Global.spreadTypeList[1]
    update_grafiikkatilet() # ei kuulu ajaa joka framella, täällä testitarkotuksena
