extends Line2D
@export var projectile: Projectile
@export var maxLength: int

var queue: Array



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue.push_front(projectile.global_position)
	if queue.size() > maxLength:
		queue.pop_back()
	clear_points()
	for point in queue:
		add_point(point)
