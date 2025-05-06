extends Node

@onready var ui_manager: Control = $UIManager
@onready var player: CharacterBody3D = $Player
@onready var enemy_spawner: Node = $EnemySpawner

var game_active: bool = false
var current_level: int = 1

func _ready():
    # Initialize UI
    ui_manager.initialize_ui()
    
    # Connect events
    Events.connect("person_healed", ui_manager, "_on_person_healed")
    
    # Initialize game state
    start_new_game()

func start_new_game():
    game_active = true
    current_level = 1
    ui_manager.update_level_display(current_level)
    spawn_enemies()

func spawn_enemies():
    # Add your enemy spawning logic here
    pass

func game_over():
    game_active = false
    # Add game over logic here
    pass

func _process(delta):
    if game_active:
        # Add any game-wide updates here
        pass
