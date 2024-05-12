class_name EnemyProjectile extends Area2D

var velocity: Vector2 = Vector2.ZERO

func _ready():
    $DespawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    self.position.x += self.velocity.x
    self.position.y += self.velocity.y

func _on_despawn_timer_timeout():
    self.queue_free()
