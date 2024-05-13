class_name Player extends Node2D

@export var maxHealth: int = 100
var currHealth: int

@export var maxRage: int = 10
var currRage: int
var rageActive: bool

var gravityUp: Vector2 = Vector2(0, -0.5)
var gravityDown: Vector2 = Vector2(0, -1)
var currVelocity: Vector2 = Vector2.ZERO
var jumpVelocity: Vector2 = Vector2(0, 10)
@onready var initPosition: Vector2 = self.position
var isJumping: bool = false

@onready var hitbox = $Hitbox
@onready var initCollisionMask = $Hitbox.collision_mask
@onready var dodgeTimer = $DodgeTimer
var isDodging: bool = false

@onready var sprite = $Sprite

func _ready():
    currHealth = maxHealth
    currRage = 0
    rageActive = false
    $AnimationPlayer.current_animation = "idle"

func _process(delta):
    if currVelocity.y > 0: # if player is still jumping up
        currVelocity.y = clamp(currVelocity.y + gravityUp.y, -50, 50)
    if currVelocity.y <= 0 and isJumping: # if player is falling
        $AnimationPlayer.current_animation = "fall_down"
        currVelocity.y = clamp(currVelocity.y + gravityDown.y, -50, 50)
    position.y = clamp(position.y - currVelocity.y, -999999, initPosition.y) # max y is -99999 because negative Y is north
    if position.y == initPosition.y and isJumping:
        $AnimationPlayer.current_animation = "idle"
        isJumping = false

func attack():
    print("Player attacked!")

func special():
    print("Player used special!")
    currRage = 0
    rageActive = false

func jump():
    if not isJumping and not isDodging:
        isJumping = true
        $AnimationPlayer.current_animation = "jump_up"
        currVelocity = jumpVelocity

func dodge():
    if not isDodging and not isJumping:
        print("Player dodged")
        dodgeTimer.start()
        isDodging = true
        $AnimationPlayer.current_animation = "dodge"
        hitbox.collision_mask = 0

func take_damage(damage: int):
    currHealth = clamp(currHealth - damage, 0, maxHealth)
    currRage = clamp(currRage + 5, 0, maxRage)
    if currRage == maxRage:
        rageActive = true

func _on_hitbox_area_entered(area):
    take_damage(5)

func _on_dodge_timer_timeout():
    if isDodging:
        isDodging = false
        $AnimationPlayer.current_animation = "idle"
        hitbox.collision_mask = initCollisionMask
