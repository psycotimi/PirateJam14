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
            updatetroops()
            return
            
        # jos jo yksi ruutu valittu, valitaan kohdealue
        elif selectedAlue != null && valinta != null:
            kohdexy = valinta
            liikuHyokkaa(selectedAlue, kohdexy)
            return
        # valitaan alue
        elif alueet[(valinta)].spread == Global.spreadTypeList[1] && alueet[(valinta)].troops > 0 && Global.whoseTurn == Global.spreadTypeList[1]:
            selectedAlue = valinta
            update_alueet()
            updatetroops()
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
        if alueet[str(alue)].spread == Global.whoseTurn && Global.spreadTypeList[1] == Global.whoseTurn && alueet[str(alue)].troops > 0 && selectedAlue == null:
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
        updatetroops()
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
        $liikesound.pitch_scale = randf_range(1.5,2.5)
        $liikesound.play()
        alueet[str(lahto)].troops -= 1
        alueet[str(kohde)].troops += 1
        updatetroops()
        
        #print("lahtöalueen troops: ",alueet[str(lahto)].troops," | kohdealueen troops: ",alueet[str(kohde)].troops)
    #print("whose turn: ", Global.whoseTurn, "  turnmodulo: ", turnModulo, "  turncounter", Global.turnCounter)
    update_alueet()
    updateTurn()
     
# hyökkäys
func hyokkaa(lahto, kohde):
    var hyokkaajia = alueet[str(lahto)].troops
    var puolustajia = alueet[str(kohde)].troops
    var randomlosses = randf_range(0,1)
    $attacksound.pitch_scale = randf_range(1.5,3)
    $attacksound.play()
    if battle.did_attacker_win(hyokkaajia, puolustajia):
        alueet[str(kohde)].troops = 0
        #voittajallakin chanssi menettää unitteja
        if randomlosses < 0.5 && alueet[str(lahto)].troops > 1:
            alueet[str(lahto)].troops -= 1
            randomlosses = randf_range(0,1)
            if randomlosses < 0.33 && alueet[str(lahto)].troops > 1:
                alueet[str(lahto)].troops -= 1
        liiku(lahto,kohde)
    else:
        alueet[str(lahto)].troops = 0
        #voittajallakin chanssi menettaa unittei
        if randomlosses < 0.5 && alueet[str(kohde)].troops > 1:
            alueet[str(kohde)].troops -= 1
            if randomlosses < 0.33 && alueet[str(kohde)].troops > 1:
                alueet[str(kohde)].troops -= 1
        updateTurn()
                 
#poistaa legalmovet ja troopit näkyvistä
func removeLegalmoves():
    for x in range(offsetX, gridSize+offsetX):
        for y in range(offsetY, gridSize+offsetY):
            erase_cell(3, Vector2i(x,y))
            erase_cell(2, Vector2i(x,y))

func update_alueet():
    var playerwon = false
    var playerlost = false
    var pbtroops = 0
    var jamtroops = 0
    
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
                #wincondition ja losecondition
    for alue in pbalueet:
        pbtroops += alueet[str(alue)].troops
    for alue in jamalueet:
        jamtroops += alueet[str(alue)].troops
    Global.pbTroopCount = pbtroops
    Global.jamTroopCount = jamtroops
    print(pbtroops,jamtroops)
    $UI.update_troop_count()
    if pbalueet == [] or pbtroops == 0:
        playerlost = true
    if jamalueet == [] or jamtroops == 0:
        playerwon = true
        

func alueenValinta():
    var alue = alue_under_mouse()
    updatetroops()
    if alueet.has(alue):
        #print("selected alue: " + str(alue), " | Troops in alue: ", +(alueet[str(alue)].troops))
        return(alue)

func ainvuoro():
    update_alueet()
    var siirto = await $AI.selectmove(alueet, pbalueet,jamalueet)
    if siirto != []:
        liikuHyokkaa(str(siirto[0]),str(siirto[1]))
    else:
        updateTurn()
    updatetroops()

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

func spawnaaukkoja():
    var spawnmaara = 2
    var yritauudestaan = 0
    var endlessloop = 0
    var spawnattu = 0
    while spawnattu < spawnmaara:
        var x = randi_range(0,7)
        var y = randi_range(0,7)
        endlessloop += 1
        #estää looppaamasta jos kenttä täynnä joukkoja
        if endlessloop > 100:
            return
        # yrittää pari kertaa löytää hillotonta
        if alueet[str(Vector2i(x,y))].spread != Global.spreadTypeList[0] && yritauudestaan < 2:
            yritauudestaan += 1
            continue
        if alueet[str(Vector2i(x,y))].troops >= Global.troopCountMax-1:
            continue
        else:
            alueet[str(Vector2i(x,y))].troops += 1
            spawnattu += 1
    updatetroops()
    
func updateTurn():
    Global.turnCounter += 1
    turnModulo = Global.turnCounter % 2 + 1
    Global.whoseTurn = Global.spreadTypeList[turnModulo]    
    $UI.update_turn_counter()
    $UI.update_turn_arrow()
    $UI.update_troop_count()
    
    if Global.whoseTurn == "jam":
        ainvuoro()
        spawnaaukkoja()
