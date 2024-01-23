extends Control

# käynnistä peli, kun painetaan play
func _on_play_pressed():
    await buttonsound()
    get_tree().change_scene_to_file("res://assets/Level/TestGame/test_game.tscn")

# avaa options
func _on_options_pressed():
    await buttonsound()
    get_tree().change_scene_to_file("res://menut/optionsMenu.tscn")
    

# sulje peli
func _on_quit_pressed():
    await buttonsound()
    get_tree().quit()

func buttonsound():
    $buttonsound.pitch_scale = randf_range(2,3)
    $buttonsound.play()
    await get_tree().create_timer(0.1).timeout
