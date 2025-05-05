extends CharacterBody3D

@export var speed: float = 3.0
@export var healed_speed: float = 5.0
@export var chase_distance: float = 10.0

var is_healed = false
var is_chasing = false

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area: Area3D = $Area3D

func _physics_process(delta: float) -> void:
	if not player or is_healed:
		return

	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	is_chasing = distance_to_player <= chase_distance
	

	if player and is_chasing:
		var player_pos = player.global_transform.origin
		nav_agent.set_target_position(player_pos)

	if not is_healed:
		move_towards_target(delta, speed)
	else:
		move_towards_target(delta, healed_speed)

	nav_agent.set_velocity(velocity)


func move_towards_target(delta, move_speed):
	if nav_agent.is_navigation_finished():
		return
	
	var next_path_position = nav_agent.get_next_path_position()
	var direction = (next_path_position - global_transform.origin).normalized()
	
	velocity = direction * move_speed
	move_and_slide()


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("bullet") and not is_healed:
		is_healed = true
		anim.play("StandingUp(2)0")
		is_chasing = false
		await anim.animation_finished

		# Notify the GameManager that this person has been healed
		var game_manager = get_tree().get_first_node_in_group("game_manager")
		if game_manager:
			game_manager.person_healed()

		queue_free()
