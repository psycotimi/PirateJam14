extends Control

# Nappulat joilla palataan main menuun ja mutetaan kaikki äänet

func _on_back_pressed():
    get_tree().change_scene_to_file("res://menu.tscn")


func _on_mute_pressed():
    var bus_idx = AudioServer.get_bus_index("Master")
    AudioServer.set_bus_mute(bus_idx, true) # or false
