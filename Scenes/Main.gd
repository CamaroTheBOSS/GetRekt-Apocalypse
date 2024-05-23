extends Node2D
signal playerDeath

@onready var player = $Player
@onready var waveController = $WaveController
@onready var winMenu = $WinMenu
@onready var mainMenu = $MainMenu

func onPlayerDeath():
	waveController.waveTimer.stop()
	playerDeath.emit()
	
func onBossDeath(boss):
	await GlobalData.cutSceneEnd
	winMenu.open()
	
func _ready():
	player.onDeath.connect(onPlayerDeath)
	GlobalData.bossKilled.connect(onBossDeath)
	get_tree().paused = true
	mainMenu.open()

func _process(delta):
	if player.dead and Input.is_action_just_pressed("reset"):
		GlobalData.resetGame()
	
