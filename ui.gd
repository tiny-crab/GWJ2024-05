extends CanvasLayer

var player: Player
var enemy: Enemy
var state: GameState
var started: bool = false

signal player_attack_input
signal player_special_input
signal player_jump_input
signal player_dodge_input

signal enemy_attack_input
signal enemy_special_input

func start():
    started = true

func _process(delta):
    if started:
        sync_player_ui()
        sync_enemy_ui()

func sync_player_ui():
    $Player/Bars/HealthBar.max_value = player.maxHealth
    $Player/Bars/HealthBar.value = player.currHealth
    $Player/Bars/RageBar.max_value = player.maxRage
    $Player/Bars/RageBar.value = player.currRage
    $Player/Indicators/TurnIndicator.visible = state.isPlayerTurn
    $Player/Indicators/RageIndicator.visible = player.rageActive

func sync_enemy_ui():
    $Enemy/Bars/HealthBar.max_value = enemy.maxHealth
    $Enemy/Bars/HealthBar.value = enemy.currHealth
    $Enemy/Bars/RageBar.max_value = enemy.maxRage
    $Enemy/Bars/RageBar.value = enemy.currRage
    $Enemy/Indicators/TurnIndicator.visible = !state.isPlayerTurn
    $Enemy/Indicators/RageIndicator.visible = enemy.rageActive

func _on_player_attack_pressed():
    emit_signal("player_attack_input")

func _on_player_special_pressed():
    emit_signal("player_special_input")

func _on_player_debug_jump_pressed():
    emit_signal("player_jump_input")

func _on_player_debug_dodge_pressed():
    emit_signal("player_dodge_input")

func _on_enemy_attack_pressed():
    emit_signal("enemy_attack_input")

func _on_enemy_special_pressed():
    emit_signal("enemy_special_input")
