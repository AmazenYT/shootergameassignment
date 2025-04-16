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
	print("Distance to player:", distance_to_player, " | Chasing:", is_chasing)

	if is_chasing:
		nav_agent.set_target_position(player.global_transform.origin)

		if not nav_agent.is_navigation_finished():
			var current_speed = healed_speed if is_healed else speed
			move_towards_target(delta, current_speed)
	


func move_towards_target(delta: float, move_speed: float) -> void:
	var next_path_position = nav_agent.get_next_path_position()
	var direction = (next_path_position - global_transform.origin).normalized()
	print("Moving towards:", next_path_position)
	velocity = direction * move_speed
	move_and_slide()


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("bullet") and not is_healed:
		is_healed = true
		anim.play("StandingUp(2)0")
		is_chasing = false
		await anim.animation_finished
		queue_free()
