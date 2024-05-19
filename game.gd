extends Node2D

@onready var state: GameState = GameState.new()
var isPlayerAttacking: bool = false

@onready var playerHitSounds = [
    preload("res://assets/sounds/playerhit2/hit1.ogg"),
    preload("res://assets/sounds/playerhit2/hit2.ogg"),
    preload("res://assets/sounds/playerhit2/hit3.ogg"),
    preload("res://assets/sounds/playerhit2/hit4.ogg"),
    preload("res://assets/sounds/playerhit2/hit5.ogg"),
]

@onready var uiSounds = [
    preload("res://assets/sounds/uiclicks/mouseclick1.ogg"),
    preload("res://assets/sounds/uiclicks/switch17.ogg"),
    preload("res://assets/sounds/uiclicks/switch18.ogg"),
    preload("res://assets/sounds/uiclicks/switch19.ogg"),
]

func _ready():
    $UI.player = $Player
    $UI.enemy = $Enemy
    $UI.state = state
    state.isPlayerTurn = true
    $UI.start()

func _process(delta):
    if Input.is_action_pressed("player_dodge") and not state.isPlayerTurn:
        $Player.dodge()
    if Input.is_action_pressed("player_jump") and not state.isPlayerTurn:
        $Player.jump()
    if $Player.currRage == $Player.maxRage:
        $UI/Player/Actions/Special.visible = true
    else:
        $UI/Player/Actions/Special.visible = false
    if $Player.currHealth == 0:
        game_over()
    if $Enemy.currHealth == 0:
        you_win()

func _on_player_attack_pressed():
    $AudioStreamPlayer2D.stream = uiSounds.pick_random()
    $AudioStreamPlayer2D.play()
    if state.isPlayerTurn and not isPlayerAttacking:
        $Player.attack()
        isPlayerAttacking = true

func _on_player_special_pressed():
    $AudioStreamPlayer2D.stream = uiSounds.pick_random()
    $AudioStreamPlayer2D.play()
    if state.isPlayerTurn and $Player.rageActive:
        $Player.special()

func _on_player_turn_complete():
    end_player_turn()

func _on_enemy_turn_complete():
    end_enemy_turn()

func end_player_turn():
    isPlayerAttacking = false
    state.isPlayerTurn = false
    $UI/Hint.visible = true
    var tween = get_tree().create_tween()
    tween.tween_callback(choose_enemy_action).set_delay(1)

func choose_enemy_action():
    if $Enemy.currRage == $Enemy.maxRage:
        $Enemy.special()
    else:
        $Enemy.attack($EnemyMeleePosition.global_position)

func end_enemy_turn():
    $UI/Hint.visible = false
    state.isPlayerTurn = true

func _on_enemy_attack_pressed():
    if not state.isPlayerTurn:
        $Enemy.attack($EnemyMeleePosition.global_position)

func _on_enemy_special_pressed():
    if not state.isPlayerTurn and $Enemy.rageActive:
        $Enemy.special()

func _on_player_jump_pressed():
    $Player.jump()

func _on_player_dodge_pressed():
    $Player.dodge()

func _on_player_hit_target():
    $AudioStreamPlayer2D.stream = playerHitSounds.pick_random()
    $AudioStreamPlayer2D.play()
    $Enemy.take_damage(5)

func game_over():
    $TextureRect.visible = false
    $UI.visible = false
    $Player.visible = false
    $Enemy.visible = false
    $DRRR.visible = true
    var tween = get_tree().create_tween()
    tween.tween_property($DRRR/DRRR1, "modulate", Color("ffffff"), 1)
    tween.tween_property($DRRR/DRRR2, "modulate", Color("ffffff"), 1)
    tween.tween_property($DRRR/DRRR3, "modulate", Color("ffffff"), 1)
    tween.tween_property($DRRR/DRRR4, "modulate", Color("ffffff"), 1)
    tween.tween_property($DRRR/DRRR5, "modulate", Color("ffffff"), 60)

func you_win():
    var menu = preload("res://main_menu.tscn").instantiate()
    get_tree().root.add_child(menu)
    get_tree().root.remove_child(self)
