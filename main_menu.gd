extends Node2D

@onready var playButton = $UI/CenterContainer/VBoxContainer/PlayButton
@onready var exitButton = $UI/CenterContainer/VBoxContainer/ExitButton

func _on_play_button_mouse_entered():
    playButton.modulate = Color("#666666")

func _on_play_button_mouse_exited():
    playButton.modulate = Color("#ffffff")

func _on_play_button_pressed():
    var game = preload("res://game.tscn").instantiate()
    get_tree().root.add_child(game)
    get_tree().root.remove_child(self)

func _on_exit_button_mouse_entered():
    exitButton.modulate = Color("#666666")

func _on_exit_button_mouse_exited():
    exitButton.modulate = Color("#ffffff")

func _on_exit_button_pressed():
    $UI.visible = false
    $DRRR.visible = true
    var tween = get_tree().create_tween()
    tween.tween_property($DRRR/DRRR1, "modulate", Color("ffffff"), 1)
    tween.tween_property($DRRR/DRRR2, "modulate", Color("ffffff"), 1)
    tween.tween_property($DRRR/DRRR3, "modulate", Color("ffffff"), 1)

