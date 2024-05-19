extends Node2D

@onready var state: GameState = GameState.new()
var isPlayerAttacking: bool = false

func _ready():
    $UI.player = $Player
    $UI.enemy = $Enemy
    $UI.state = state
    state.isPlayerTurn = true
    $UI.start()

func _process(delta):
    if Input.is_action_pressed("player_dodge"):
        $Player.dodge()
    if Input.is_action_pressed("player_jump"):
        $Player.jump()
    if $Player.currRage == $Player.maxRage:
        $UI/Player/Actions/Special.visible = true
    else:
        $UI/Player/Actions/Special.visible = false

func _on_player_attack_pressed():
    if state.isPlayerTurn and not isPlayerAttacking:
        $Player.attack()
        isPlayerAttacking = true

func _on_player_special_pressed():
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
    $Enemy.take_damage(5)
