extends State
class_name EnemyWalkAndShootAround

@export var entity: Entity
@export var moveSpeed := 200.
@export var _weaponMarker: Marker2D

var firstShootTimer = Timer.new()
var direction: Vector2 = Vector2.RIGHT
var player: Player
	
func enter():
	player = get_tree().get_first_node_in_group("Player")
	var angle = randf_range(-PI, PI) * 2
	direction = Vector2.from_angle(angle)
	firstShootTimer.wait_time = 2.5
	firstShootTimer.one_shot = true
	add_child(firstShootTimer)
	firstShootTimer.start()
	
func update(delta: float):
	pass
	
func shoot():
	if !firstShootTimer.is_stopped() or entity.dead:
		return
	for weapon in _weaponMarker.get_children():
		weapon.shoot((entity.global_position - weapon.global_position).normalized(), "Player")

func modifyDirection(delta: float):
	var nextPosition = entity.position + direction.normalized() * 100
	var spaceState = entity.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(entity.position, nextPosition)
	query.exclude = [self]
	var result = spaceState.intersect_ray(query)
	if result and !result["collider"] is Player:
		var angle = randf_range(-PI, PI) * 2
		direction = Vector2.from_angle(angle)
	else:
		var angle = randf_range(-PI, PI) / 50
		direction = direction.rotated(angle)
		
func physicsUpdate(delta: float):
	if !player or !entity:
		return
	modifyDirection(delta)
	shoot()
	entity.velocity = direction.normalized() * moveSpeed
