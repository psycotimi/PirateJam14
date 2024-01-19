extends Control

# käynnistä peli, kun painetaan play
func _on_play_pressed():
   get_tree().change_scene_to_file("res://assets/Level/TestGame/test_game.tscn")

# avaa options
func _on_options_pressed():
   get_tree().change_scene_to_file("res://menut/optionsMenu.tscn")

# sulje peli
func _on_quit_pressed():
   get_tree().quit()
