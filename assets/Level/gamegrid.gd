extends TileMap

var gridSize = Global.gridsize
var tiles = {}
var alueet = {}
var alueetbyid = {} 

var troopLabel = Label.new()
var offsetX = 23
var offsetY = 12

var selectedAlue
var targetAlue

var xAlku = 0
var yAlku = 0


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
                "areaid" : 0, # tätä voi käyttää myöhemmin
                "grafiikkatilet" : grafiikkatilet,
            }
            set_cell(0, Vector2i(x,y), 0, Vector2i(0,0),0)
            add_layer(1)
            add_layer(2)
            add_layer(3)
            set_cell(2, Vector2i(x,y), 0, Vector2i(0,0),0)
            set_cell(3, Vector2i(x,y), 0, Vector2i(0,0),0)
    # print(tiles) #Testi, että dictionary tulostuu oikein

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
                "areaid" : areaid,
                "spread" : Global.spreadTypeList[0],
                "troops" : 0, # 0-3 solttuleipää
                "ruudut" : ruudut,
                "legalmoves" : legalmoves
            }
            alueetbyid[areaid] = { 
                "legalmoves" : legalmoves,
                "positio" : Vector2i(x,y),
                "ruudut" : ruudut
            }
            for ruutu in ruudut:
                if tiles.has(str(ruutu)):
                    tiles[str(ruutu)].areaid = areaid  
            ruutuoffsety += 1
        ruutuoffsetx += 1
        
         
    for n in 5:
        alkupositio()
        alkupositio2()
    sijoitaTroopitAlueille()
    #print(alueet)
    update_grafiikkatilet()
    
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
 
func alue_under_mouse():
    var tile = tile_under_mouse()
    if tiles.has(tile):
        var areaid = tiles[str(local_to_map(get_global_mouse_position()))].areaid
        for alue in alueet:
            if alueet[alue].areaid == areaid:
                return str(alue)


# Kun hiirellä painetaan ruutua, valitaan kyseinen ruutu ja painamalla uudestaan, valitaan toinenkin ruutu   
func _input(_event):
    
    if Input.is_action_just_pressed("select_tile"):
        # poistaa legalmovet näkyvistä, ja sotilaat
        removeLegalmoves()
        # asettaa sotilaat asemiin ja tarkistaa lailliset siirrot
        update_alueet()
        # alueenValinta palauttaa kaksi aluetta, voi muokata jotenkin jos sekavaa
        var valinta = alueenValinta()
        # estää kaatumisen jos klikkaa ohi leivästä
        if !valinta:
            return
        selectedAlue = valinta[0]
        targetAlue = valinta[1]
        
        if valinta[1] != null:
            valitseRuutuJostaHyokataan(selectedAlue, targetAlue)

# Arvotaan aloitusruudut peanut butterille ja laitetaan joka ruutuun myös yksi troop
func alkupositio(): #muuta tää kutsumaan aluetta, koordinaatit 0:0 - 7:7
    xAlku = randi_range(0,3)
    yAlku = randi_range(0,7)
    if alueet[str(Vector2i(xAlku,yAlku))].spread == Global.spreadTypeList[1]:
        alkupositio()
    else:
        alueet[str(Vector2i(xAlku,yAlku))].spread = Global.spreadTypeList[1]
        alueet[str(Vector2i(xAlku,yAlku))].troops = 1

# Arvotaan aloitusruudut peanut hillolle ja laitetaan joka ruutuun myös yksi troop
func alkupositio2():
    xAlku = randi_range(4,7)
    yAlku = randi_range(0,7)
    if alueet[str(Vector2i(xAlku,yAlku))].spread == Global.spreadTypeList[2]:
        alkupositio2()
    else:
        alueet[str(Vector2i(xAlku,yAlku))].spread = Global.spreadTypeList[2]
        alueet[str(Vector2i(xAlku,yAlku))].troops = 1

# vaihtaa alueen, alueen ruutujen, ja ruutujen grafiikkatilejen hilloa.
func setAlueSpread(alue,spread):
    alueet[alue].spread = spread
    for ruutu in alueet[alue].ruudut:
        tiles[str(ruutu)].spread = spread 
        $grafiikkatilet.setSpread(tiles[str(ruutu)].grafiikkatilet,tiles[str(ruutu)].spread)

# piirtää ukkelit alueille, joissa troops > 0
func sijoitaTroopitAlueille():
    for alue in alueet:
        var ruudut = alueet[alue].ruudut
        for x in range(0,alueet[str(alue)].troops):
            print(ruudut[x])
            tiles[str(ruudut[x])].troops = 1
            set_cell(2,ruudut[x],3,Vector2i(0,0),0)

# tarkastetaan onko valittu ruutu PEANUTbutter aluetta, ja onko siinä tropppeja, Mikäli liikutaan tai hyökätään, kutsutaan kyseisiä funktioita.
# tekemättä tästä: kutsua hyökkäystä, kutsua liikkumista
func valitseRuutuJostaHyokataan(alue, kohde):
        if alueet[(alue)].spread == Global.spreadTypeList[1] && alueet[(alue)].troops != 0 && Global.whoseTurn == Global.spreadTypeList[1]:
            for legalmove in alueet[str(alue)].legalmoves:
                for ruutu in alueet[str(legalmove)].ruudut:
                    set_cell(3, ruutu, 4,Vector2i(0,0),0)
                    #liiku(lahto,kohde)
                    #hyokkaa()

# liikkuminen
func liiku(lahto, kohde):
    print(lahto, kohde)
    
# hyökkäys
func hyokkaa(lahto, kohde):
    print(lahto, kohde)
                   
#poistaa legalmovet näkyvistä
func removeLegalmoves():
    for x in range(offsetX, gridSize+offsetX):
        for y in range(offsetY, gridSize+offsetY):
            erase_cell(3, Vector2i(x,y))
            erase_cell(2, Vector2i(x,y))

func update_alueet():
    sijoitaTroopitAlueille()
    for alue in alueet:
        alueet[str(alue)].legalmoves = alueetbyid[alueet[str(alue)].areaid].legalmoves
        # laillisten siirtojen laillisuuden tarkistus
        for legalmove in alueet[alue].legalmoves:
            if !alueet.has(str(legalmove)):
                #print(legalmove, " pitäisi poistaa")
                # poistetaan gridin ulkopuoliset siirrot laillisista siirroista
                alueet[alue].legalmoves.erase(legalmove)
                continue
            # jos ruutu on oma ja ruudussa on jo 3 solttu, se ei ole laillinen
            if alueet[str(legalmove)].troops >= 3 && alueet[str(legalmove)].spread == alueet[str(alue)].spread:
                alueet[alue].legalmoves.erase(legalmove)
                continue

func alueenValinta():
    var alue = alue_under_mouse()
    if alueet.has(alue):
            if targetAlue != null:
                selectedAlue = alue
                targetAlue = null
            elif selectedAlue != null:
                targetAlue = alue
            else:
                selectedAlue = alue
            # setAlueSpread(alue,Global.spreadTypeList[1]) # muuttaa hiiren alla olevan alueen peanutbutteriksi
            # update_grafiikkatilet() # ei kuulu ajaa joka framella, täällä testitarkotuksena
            print("selected alue: " + str(selectedAlue), " | target alue: " + str(targetAlue), " | Troops in alue: ", +(alueet[str(alue)].troops))
            return([selectedAlue,targetAlue])
