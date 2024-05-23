@tool
extends StaticBody2D

@onready var border = $BorderRect
@onready var hitbox = $Hitbox
@onready var lightOccluder = $LightOccluder2D

@export var size: Vector2 = Vector2(100, 100):
	set(newSize):
		size = newSize
		changeSize(newSize)
			
			
func changeSize(newSize):
	if border:
			border.size = newSize
	if hitbox:
		hitbox.shape = RectangleShape2D.new()
		hitbox.shape.size = newSize
		hitbox.position = border.position + border.size / 2
	if lightOccluder:
		lightOccluder.occluder = OccluderPolygon2D.new()
		var polygon = PackedVector2Array()
		polygon.append(Vector2(0, 0))
		polygon.append(Vector2(newSize.x, 0))
		polygon.append(newSize)
		polygon.append(Vector2(0, newSize.y))
		lightOccluder.occluder.polygon = polygon


# Called when the node enters the scene tree for the first time.
func _ready():
	changeSize(size)
