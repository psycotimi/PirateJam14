extends Control

# Nappulat joilla palataan main menuun ja mutetaan kaikki äänet

func _on_back_pressed():
    get_tree().change_scene_to_file("res://menut/menu.tscn")


func _on_mute_pressed():
    if $AnimatedSprite2D.get_frame() == 0:
        
        # mutee kaikki äänet
        var bus_idx = AudioServer.get_bus_index("Master")
        AudioServer.set_bus_mute(bus_idx, true) 
        
        # Vaihda kuvake
        $AnimatedSprite2D.set_frame(1)
    
    else:
        $AnimatedSprite2D.set_frame(0)
        var bus_idx = AudioServer.get_bus_index("Master")
        AudioServer.set_bus_mute(bus_idx, false)
