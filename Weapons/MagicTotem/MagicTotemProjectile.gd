extends Area2D
class_name SpectralProjectile

@onready var lifeTimer = $LifeTimer

var speed: float = 100
var damage: float = 50.

var targetGroup: String = ""
var direction: Vector2 = Vector2.RIGHT
var radiusVector: Vector2 = Vector2.RIGHT
var radius: float = 1
var rotationSpeed: float = 2
var spiralSpeed: float = 50
var lifeTime: float = 4
var projectileOwner
var lastProjectileOwnerPosition: Vector2 = Vector2(0, 0)



func destroy():
	if is_instance_valid(self):
		hide()
		queue_free()

		
func onCollisionWithBody(body: Node2D):
	if body is Entity and body.is_in_group(targetGroup):
		body.dealDamage(damage)
	

func _ready():
	body_entered.connect(onCollisionWithBody)
	lifeTimer.wait_time = lifeTime
	lifeTimer.timeout.connect(destroy)
	lifeTimer.start()
	scale = scale + Vector2(0.2, 0.2) * damage
	radiusVector = direction.normalized()
	if projectileOwner and is_instance_valid(projectileOwner):
		lastProjectileOwnerPosition = projectileOwner.global_position
	
	
func checkCollisionInNextFrame(nextPosition: Vector2):
	var spaceState = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, nextPosition)
	query.exclude = [self]
	var result = spaceState.intersect_ray(query)
	return result
	

func _process(delta):
	if projectileOwner and is_instance_valid(projectileOwner):
		lastProjectileOwnerPosition = projectileOwner.global_position
	radius += spiralSpeed * delta
	radiusVector = radiusVector.rotated(rotationSpeed / radius * delta).normalized() * radius
	var nextPosition = lastProjectileOwnerPosition + radiusVector
	var collisions = checkCollisionInNextFrame(nextPosition)
	if collisions:
		onCollisionWithBody(collisions["collider"])
	position = nextPosition
