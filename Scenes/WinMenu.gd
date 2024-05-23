extends CanvasLayer

@onready var mainMenuButton: Button = $Control/MainMenu
@onready var tryAgainButton: Button = $Control/TryAgain
@export var mainMenu: CanvasLayer


func open():
	get_tree().paused = true
	show()
	
func close():
	hide()
	
func onMainMenu():
	mainMenu.open()
	hide()
	
func onTryAgain():
	get_tree().paused = false
	GlobalData.resetGame()
	close()

func _ready():
	mainMenuButton.pressed.connect(onMainMenu)
	tryAgainButton.pressed.connect(onTryAgain)
