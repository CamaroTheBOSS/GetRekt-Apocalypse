extends State
class_name EnemyWalkAndShootHarder

@export var entity: Entity
@export var moveSpeed := 200.
@export var _weapon: Weapon

var firstShootTimer = Timer.new()
var direction: Vector2 = Vector2.RIGHT
var player: Player

var isFacingRight: bool = true
	
func enter():
	player = get_tree().get_first_node_in_group("Player")
	var angle = randf_range(-PI, PI) * 2
	direction = Vector2.from_angle(angle)
	firstShootTimer.wait_time = 4
	firstShootTimer.one_shot = true
	add_child(firstShootTimer)
	firstShootTimer.start()
	
func update(delta: float):
	pass
	
func shoot():
	if !firstShootTimer.is_stopped() or entity.dead:
		return
	_weapon.shoot(Vector2.from_angle(_weapon.global_rotation), "Player")

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
	
	if _weapon and !entity.dead:
		var playerDirection = player.global_position - _weapon.global_position
		_weapon.global_rotation = lerp_angle(_weapon.global_rotation, playerDirection.angle(), 5 * delta)
		if abs(_weapon.global_rotation) > PI / 2 and isFacingRight:
			isFacingRight = false
			_weapon.scale.y = -_weapon.scale.y
		if abs(_weapon.global_rotation) <= PI / 2 and not isFacingRight:
			isFacingRight = true
			_weapon.scale.y = -_weapon.scale.y
