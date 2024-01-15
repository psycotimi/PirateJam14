extends TileMap

var gridSize = 16
var tiles = {}
var prevtile = Vector2i(0,0)
var troopLabel = Label.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in gridSize:
		for y in gridSize:
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
			tiles[Vector2(x,y)] = {
				"surface" : Global.spreadTypeList[2], # aluksi hilloton
				"troops" : 0, # joukkojen lukumäärä tilellä, ehkä pitää siirtää alueeseen sitku semmonen on
				"areaid" : 0, # tätä voi käyttää myöhemmin
				"grafiikkatilet" : grafiikkatilet,
				"legalmoves" : legalMoves
			}
			set_cell(0, Vector2(x,y), 0, Vector2(0,0),0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func get_tile_under_mouse():
	var tile = local_to_map(get_global_mouse_position())
	print("käydäänkö tässä?")
	if tile in tiles:
		print("entä tässä?")
		print(tile)
		return tiles[tile]
	
