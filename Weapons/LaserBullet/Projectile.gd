extends Area2D
class_name Projectile

@onready var screenNotifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var explosionScene: PackedScene = preload("res://Weapons/LaserBullet/Explosion.tscn")

var speed: float = 100
var damage: float = 50.

var targetGroup: String = ""
var direction: Vector2 = Vector2.RIGHT



func destroy():
	if is_instance_valid(self):
		hide()
		queue_free()
		
func explode():
	if targetGroup != "HitableEnemy":
		return
	GlobalData.playExplosionSound()
	var explosion = explosionScene.instantiate()
	explosion.damage = damage
	explosion.targetGroup = targetGroup
	explosion.global_position = global_position
	get_tree().root.add_child(explosion)
		
		
func onCollisionWithBody(body: Node2D):
	if body is Entity and body.is_in_group(targetGroup):
		body.dealDamage(damage)
		destroy()
	elif body is StaticBody2D:
		destroy()
		
		
func onCollisionWithArea(area):
	if area is Projectile and area.targetGroup != targetGroup and !(area is BossProjectile):
		area.destroy()
		explode()
		destroy()
	

func _ready():
	body_entered.connect(onCollisionWithBody)
	area_entered.connect(onCollisionWithArea)
	screenNotifier.screen_exited.connect(destroy)
	scale = scale + Vector2(0.2, 0.2) * damage
	
	
func checkCollisionInNextFrame(nextPosition: Vector2):
	var spaceState = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, nextPosition)
	query.exclude = [self]
	var result = spaceState.intersect_ray(query)
	return result
	

func _process(delta):
	var nextPosition = position + direction * speed * delta
	var collisions = checkCollisionInNextFrame(nextPosition)
	if collisions:
		onCollisionWithBody(collisions["collider"])
		onCollisionWithArea(collisions["collider"])
	position = nextPosition
