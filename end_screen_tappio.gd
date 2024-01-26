extends CanvasLayer


func _on_retry_pressed():
    get_tree().change_scene_to_file("res://assets/Level/TestGame/test_game.tscn")


func _on_quit_pressed():
    get_tree().quit()
