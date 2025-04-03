extends CharacterBody3D

@export var speed: float = 3.0  # Enemy movement speed
@export var healed_speed: float = 5.0  # Speed after being healed

var is_healed = false  # Tracks if the enemy has been "healed"
var is_chasing = true  # Tracks whether the enemy is still chasing the player

@onready var player = get_tree().get_first_node_in_group("player")  # Finds the player
@onready var nav_agent = $NavigationAgent3D  # Pathfinding agent
@onready var anim = $AnimationPlayer  # Animation controller
@onready var area = $Area3D  # Bullet detection area

func _physics_process(delta):
	if player and is_chasing:  # Only chase the player if is_chasing is true
		nav_agent.target_position = player.global_transform.origin  # Set target to player

		if not is_healed:  # Enemy crawls normally
			move_towards_target(delta, speed)
		else:  # Moves faster when "healed"
			move_towards_target(delta, healed_speed)

func move_towards_target(delta, move_speed):
	var next_path_position = nav_agent.target_position
	var direction = (next_path_position - global_transform.origin).normalized()
	
	velocity = direction * move_speed
	move_and_slide()

func _on_area_3d_area_entered(area: Area3D) -> void:
	print(area)
	if area.is_in_group("bullet") and not is_healed:
		is_healed = true  # Mark enemy as healed
		anim.play("StandingUp(2)0")  # Play stand-up animation
		is_chasing = false  # Stop chasing immediately when animation starts
		await anim.animation_finished  # Wait for the animation to finish
		queue_free()  # Remove enemy after standing up
	pass  # Replace with function body.
