extends CanvasLayer

@onready var startButton: Button = $Control/Start


func open():
	get_tree().paused = true
	show()
	
func close():
	hide()

func onStart():
	get_tree().paused = false
	GlobalData.resetGame()
	close()

func _ready():
	startButton.pressed.connect(onStart)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
