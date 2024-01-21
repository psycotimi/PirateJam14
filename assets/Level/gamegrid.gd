extends TileMap

var gridSize = Global.gridsize
var tiles = {}
var alueet = {}
var alueetbyid = {} 
var pbalueet = []
var jamalueet = []

var troopLabel = Label.new()
var offsetX = 23
var offsetY = 12

var selectedAlue
var targetAlue

var xAlku = 0
var yAlku = 0

var lahtoxy
var kohdexy

var turnModulo = 1

const battleScripts = preload("res://scripts/Battle.gd")
var battle
var updated = false
# Called when the node enters the scene tree for the first time.
func _ready():
    battle = battleScripts.new()
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
    if Global.whoseTurn == "jam":
       ainvuoro()
            
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


# Kun hiirellä painetaan ruutua, valitaan kyseinen ruutu
func _input(_event):
    
    if Input.is_action_just_pressed("select_tile"):
        # poistaa legalmovet näkyvistä, ja sotilaat
        # asettaa sotilaat asemiin ja tarkistaa lailliset siirrot
        # alueenValinta palauttaa kaksi aluetta, voi muokata jotenkin jos sekavaa
        var valinta = alueenValinta()
        # estää kaatumisen jos klikkaa ohi leivästä
        if !valinta:
            selectedAlue = null
            return
            
        # jos jo yksi ruutu valittu, valitaan kohdealue
        elif selectedAlue != null && valinta != null:
            kohdexy = valinta
            liikuHyokkaa(selectedAlue, kohdexy)
        # valitaan alue
        elif alueet[(valinta)].spread == Global.spreadTypeList[1] && alueet[(valinta)].troops > 0 && Global.whoseTurn == Global.spreadTypeList[1] && selectedAlue == null:
            selectedAlue = valinta
            update_alueet()
            valitseRuutuJostaHyokataan(valinta)
            
            
        # asettaa sotilaat asemiin ja tarkistaa lailliset siirrot
        # print("lahtoxy ", selectedAlue, "kohdexy ", kohdexy)

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

# piirtää ukkelit alueille, joissa troops > 0 # piirtää 
func sijoitaTroopitAlueille():
    for alue in alueet:
        # highlightaa alueen, jos on pelaajan vuoro ja alueella on joukkoja
        if alueet[str(alue)].spread == Global.whoseTurn && alueet[str(alue)].troops > 0 && selectedAlue == null:
            for ruutu in alueet[str(alue)].ruudut:
                set_cell(3, ruutu, 4,Vector2i(0,0),0)
                
# piirtää ukot alueen ruutuihin
        var ruudut = alueet[alue].ruudut
        for x in range(0,alueet[str(alue)].troops):
            set_cell(2,ruudut[x],3,Vector2i(0,0),0)

# tarkastetaan onko valittu ruutu PEANUTbutter aluetta, ja onko siinä tropppeja, Mikäli liikutaan tai hyökätään, kutsutaan kyseisiä funktioita.
# tekemättä tästä: kutsua hyökkäystä, kutsua liikkumista
func valitseRuutuJostaHyokataan(alue):
    for legalmove in alueet[str(alue)].legalmoves:
        for ruutu in alueet[str(legalmove)].ruudut:
            set_cell(3, ruutu, 4,Vector2i(0,0),0)

# tässä käydään läpi onko kyseessä hyökkäys vai liikuminen ja sen jälkeen kutsutaan oikeaa funktiota
func liikuHyokkaa(lahto, kohde):
   # if alueet[str(lahto)].legalmoves.has(str(kohde)):
       # print("alueet[str(lahto)].legalmoves")
    for legalmove in alueet[str(lahto)].legalmoves:
        selectedAlue = null
        update_alueet()
        if str(legalmove) == kohde:
            # jos alue omaa hilloa tai neutraali, liikkuu, jos mahtuu
            if (alueet[str(lahto)].spread == alueet[str(kohde)].spread or alueet[str(kohde)].spread == Global.spreadTypeList[0]) && alueet[str(kohde)].troops < Global.troopCountMax:
                liiku(lahto, kohde)
            # jos vihun alue ja alueella joukkoja, hyökkää
            elif alueet[str(lahto)].spread != alueet[str(kohde)].spread && alueet[str(kohde)].troops > 0:
                hyokkaa(lahto,kohde)
            # jos alue vihun alue ja alue tyhjä, liikuu
            else:
                liiku(lahto,kohde)

# liikkuminen
func liiku(lahto, kohde):
    # muuttaa kohteen levitteen samaksi kuin lähtöruudun
    setAlueSpread(kohde,alueet[str(lahto)].spread)
    # looppaa niin kauan kunnes lähtöruutu on tyhjä tai kohderuutu täynnä
    while (alueet[str(lahto)].troops > 0 and alueet[str(kohde)].troops < Global.troopCountMax):
        alueet[str(lahto)].troops -= 1
        alueet[str(kohde)].troops += 1
        
        #print("lahtöalueen troops: ",alueet[str(lahto)].troops," | kohdealueen troops: ",alueet[str(kohde)].troops)
    #print("whose turn: ", Global.whoseTurn, "  turnmodulo: ", turnModulo, "  turncounter", Global.turnCounter)
    Global.turnCounter += 1
    turnModulo = Global.turnCounter % 2 + 1
    Global.whoseTurn = Global.spreadTypeList[turnModulo]
    #$UI.update_turn_counter()
    update_alueet()
     
# hyökkäys
func hyokkaa(lahto, kohde):
    var hyokkaajia = alueet[str(lahto)].troops
    var puolustajia = alueet[str(kohde)].troops
    if battle.did_attacker_win(hyokkaajia, puolustajia):
        alueet[str(kohde)].troops = 0
        liiku(lahto,kohde)
    else:
        Global.turnCounter += 1
        turnModulo = Global.turnCounter % 2 + 1
        Global.whoseTurn = Global.spreadTypeList[turnModulo]
        alueet[str(lahto)].troops = 0
                 
#poistaa legalmovet näkyvistä ja vanhat troopit
func removeLegalmoves():
    for x in range(offsetX, gridSize+offsetX):
        for y in range(offsetY, gridSize+offsetY):
            erase_cell(3, Vector2i(x,y))
            erase_cell(2, Vector2i(x,y))

func update_alueet():
    updatetroops()
    for id in alueetbyid:
        var alue = alueetbyid[id].positio
        var legalmoves = generatelegalmoves(alue)
        if alueet[str(alue)].troops <= 0:
            alueet[str(alue)].legalmoves = []
        else:
            alueet[str(alue)].legalmoves = legalmoves
        if alueet[str(alue)].spread == Global.spreadTypeList[1] && !pbalueet.has(alue):
            pbalueet.append(alue)
            if jamalueet.has(alue):
                jamalueet.erase(alue)
        elif alueet[str(alue)].spread == Global.spreadTypeList[2] && !jamalueet.has(alue):
            jamalueet.append(alue)
            if pbalueet.has(alue):
                pbalueet.erase(alue)
        

func alueenValinta():
    var alue = alue_under_mouse()
    if alueet.has(alue):
        #print("selected alue: " + str(alue), " | Troops in alue: ", +(alueet[str(alue)].troops))
        return(alue)

func ainvuoro():
    if updated == false:
        update_alueet()
        updated = true
    else:
        
        var siirto = $AI.selectmove(alueet, pbalueet,jamalueet)
        if siirto != []:
            liikuHyokkaa(str(siirto[0]),str(siirto[1]))
        else:
            Global.turnCounter += 1
            turnModulo = Global.turnCounter % 2 + 1
            Global.whoseTurn = Global.spreadTypeList[turnModulo]
        updatetroops()
        updated = false

func generatelegalmoves(alue):
    var legalmoves = []
    var move 
    for x in range(alue.x-1,alue.x+2):
        for y in range(alue.y-1,alue.y+2):
            move = Vector2i(x,y)
            # jos siirto alueen ulkopuolella
            if x != alue.x and y != alue.y:
                continue
            elif x < 0 or x > 7 or y < 0 or y > 7 or alue == move:
                continue
            # jos alue on oma ja siinä on jo 4 sotilasta
            elif alueet[str(alue)].spread == alueet[str(move)].spread && alueet[str(move)].troops >= Global.troopCountMax:
                continue
                #jos ei jää kumpaankaan noista niin siirto laillinen
            else:
                legalmoves.append(move)
    return legalmoves

func updatetroops():
    removeLegalmoves()
    sijoitaTroopitAlueille()
