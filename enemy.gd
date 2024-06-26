class_name Enemy extends Node2D

signal turn_complete

@export var maxHealth: int = 100
var currHealth: int

@export var maxRage: int = 10
var currRage: int
var rageActive: bool

@onready var initPosition: Vector2 = position

@onready var projectileTemplate = load("res://enemy_projectile.tscn")

var locationToDisappearTo: Vector2
var nextAnimationAfterDisappear: String

@onready var disappearSounds = [
    preload("res://assets/sounds/vanish/impactMining_000.ogg"),
    preload("res://assets/sounds/vanish/impactMining_001.ogg"),
    preload("res://assets/sounds/vanish/impactMining_002.ogg"),
    preload("res://assets/sounds/vanish/impactMining_003.ogg"),
    preload("res://assets/sounds/vanish/impactMining_004.ogg"),
]

func _ready():
    currHealth = maxHealth
    currRage = 0
    rageActive = false

func disappear_to(global_position: Vector2, next_animation: String):
    $AnimationPlayer.current_animation = "disappear"
    nextAnimationAfterDisappear = next_animation
    locationToDisappearTo = global_position
    $AudioStreamPlayer2D.stream = disappearSounds.pick_random()
    $AudioStreamPlayer2D.play()

func _on_disappear_complete():
    position = locationToDisappearTo
    if not nextAnimationAfterDisappear.is_empty():
        $AnimationPlayer.current_animation = nextAnimationAfterDisappear
        nextAnimationAfterDisappear = ""

func attack(global_position: Vector2):
    disappear_to(global_position, "attack_single")

func attack_single_complete():
    disappear_to(initPosition, "idle")
    emit_signal("turn_complete")

func special():
    print("Enemy used special!")

    var projectile: EnemyProjectile = projectileTemplate.instantiate()
    add_child(projectile)
    projectile.position.y = 30
    projectile.velocity = Vector2(-25, 0)
    await get_tree().create_timer(0.5).timeout

    projectile = projectileTemplate.instantiate()
    add_child(projectile)
    projectile.position.y = 0
    projectile.velocity = Vector2(-25, 0)
    await get_tree().create_timer(0.5).timeout

    projectile = projectileTemplate.instantiate()
    add_child(projectile)
    projectile.position.y = -30
    projectile.velocity = Vector2(-25, 0)

    currRage = 0
    rageActive = false
    emit_signal("turn_complete")

func take_damage(damage: int):
    var tween = get_tree().create_tween()
    tween.tween_property($Sprite2D, "modulate", Color(10,10,10,10), 0.1)
    tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 1), 0.1)
    currHealth = clamp(currHealth - damage, 0, maxHealth)
    currRage = clamp(currRage + 4, 0, maxRage)
    if currRage == maxRage:
        rageActive = true

