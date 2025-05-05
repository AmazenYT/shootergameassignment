extends Node
class_name GameManager  # Optional but recommended

@export var total_people: int = 10
var people_healed: int = 0
@onready var label: Label = %EnemyCounterLabel


func _ready():
    if label == null:
        push_error("Label node not found! Check path: UI/EnemyCounterLabel")
    else:
        update_healing_label()

func person_healed():
    people_healed += 1
    update_healing_label()

    if people_healed >= total_people:
        end_game()

func update_healing_label():
    label.text = "People healed: %d / %d" % [people_healed, total_people]

func end_game():
    print("Everyone healed!")
    get_tree().change_scene_to_file("res://VictoryScreen.tscn")
