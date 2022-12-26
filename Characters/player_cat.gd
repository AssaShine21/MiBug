extends CharacterBody2D

@export var move_speed: float = 300.0
@export var start_blend_position: Vector2 = Vector2(0, -0.5)

@onready var animation_tree = $AnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")


func _ready():
	update_movement_parameters(start_blend_position)


func _physics_process(delta):
	# Note it is DOWN MINUS UP
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	# Update animation
	update_movement_parameters(direction)
	
	velocity = direction * move_speed

	move_and_slide()


func update_movement_parameters(move_input: Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Walk/blend_position", move_input) 

# Update animation tree state machine
func pick_new_state():
	if (velocity != Vector2.ZERO):
		animation_state_machine.travel("Walk")
	else:
		animation_state_machine.travel("Idle")
