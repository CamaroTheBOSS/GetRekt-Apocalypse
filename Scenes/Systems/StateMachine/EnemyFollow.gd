extends State
class_name EnemyFollow

@export var entity: Entity
@export var moveSpeed := 700.
var player: Player
	
func enter():
	player = get_tree().get_first_node_in_group("Player")
	
func update(delta: float):
	pass
		
func physicsUpdate(delta: float):
	if !player or !entity:
		return
	var direction = player.global_position - entity.global_position
	entity.velocity = direction.normalized() * moveSpeed


