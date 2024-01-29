extends Node2D



func _on_back_pressed():
    await buttonsound()
    get_tree().change_scene_to_file("res://menut/menu.tscn")  

func buttonsound():
    $buttonsound.pitch_scale = 1.5
    $buttonsound.play()
    await get_tree().create_timer(0.1).timeout


func _on_play_pressed():
    await buttonsound()
    get_tree().change_scene_to_file("res://assets/Level/TestGame/test_game.tscn")
