extends Area2D
class_name Explosion
@onready var lifeTimer: Timer = $LifeTimer

var damage: float = 50.
var targetGroup: String = ""
var collisionsChecked: bool = false

func onCollisionWithArea(area):
	if area.owner is Entity and area.owner.is_in_group(targetGroup):
		area.owner.dealDamage(damage)
	elif area is Projectile and !(area is BossProjectile):
		area.destroy()

func destroy():
	if is_instance_valid(self):
		queue_free()

func _ready():
	area_entered.connect(onCollisionWithArea)
	lifeTimer.timeout.connect(destroy)
	scale = scale + Vector2(0.2, 0.2) * damage
	
