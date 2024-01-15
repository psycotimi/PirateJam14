extends Control



func _on_play_pressed():
   get_tree().change_scene_to_file("res://assets/Level/TestGame/test_game.tscn")


func _on_options_pressed():
   get_tree().change_scene_to_file("res://optionsMenu.tscn")


func _on_quit_pressed():
   get_tree().quit()
