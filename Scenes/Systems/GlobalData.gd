extends Node
signal moneyChanged(oldMoney, newMoney)
signal timeLeftChanged(oldTimeLeft, newTimeLeft)
signal waveChanged(oldWave, newWave)
signal bossSpawned(boss)
signal bossKilled(boss)
signal cutSceneEnd
signal newGame

var timeLeft: int = 0
var wave: int = 1
var maxWaves: int = 10
var money: int = 0
var initPlayerPosition: Vector2 = Vector2(950, 550)
var initBossPosition: Vector2 = Vector2(350, 550)
var bossSpawningTime: float = 2
var bossKillingTime: float = 2
var cutScene: bool = false

@onready var explosionSound = preload("res://Sounds/explosion.wav")
@onready var audioPlayer: AudioStreamPlayer = AudioStreamPlayer.new()

func playExplosionSound():
	audioPlayer.play()

func _ready():
	audioPlayer.stream = explosionSound
	add_child(audioPlayer)

func resetGame():
	setMoney(0)
	setTimeLeft(999)
	setWave(1)
	newGame.emit()
	

func setMoney(newMoney: int):
	var oldMoney = money
	money = newMoney
	moneyChanged.emit(oldMoney, newMoney)
	
	
func setTimeLeft(newTimeLeft: int):
	var oldTimeLeft = timeLeft
	timeLeft = newTimeLeft
	timeLeftChanged.emit(oldTimeLeft, newTimeLeft)
	
func setWave(newWave: int):
	var oldWave = wave
	wave = newWave
	waveChanged.emit(oldWave, newWave)
	
func getMoney():
	return money
	
func getTimeLeft():
	return timeLeft
	
func getWave():
	return wave
	
func getMaxWaves():
	return maxWaves

func getInitPlayerPosition():
	return initPlayerPosition
	
func getInitBossPosition():
	return initBossPosition
	
func getBossSpawningTime():
	return bossSpawningTime
	
func notifyBossSpawned(boss):
	cutScene = true
	bossSpawned.emit(boss)
	await get_tree().create_timer(getBossSpawningTime()).timeout
	cutScene = false
	cutSceneEnd.emit()
	
func notifyBossKilled(boss):
	cutScene = true
	bossKilled.emit(boss)
	await get_tree().create_timer(bossKillingTime).timeout
	cutScene = false
	cutSceneEnd.emit()
	
