extends Node

@export var initialState: State
var currentState: State
var states: Dictionary = {}


func onStateTransition(newState, newStateName):
	if newState != currentState:
		return
	
	var state = states.get(newStateName.to_lower())
	if !state:
		return
	if currentState:
		currentState.exit()
		
	state.enter()
	currentState = state

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(onStateTransition)
	if initialState:
		initialState.enter()
		currentState = initialState


func _process(delta):
	if currentState:
		currentState.update(delta)
		
		
func _physics_process(delta):
	if currentState:
		currentState.physicsUpdate(delta)
