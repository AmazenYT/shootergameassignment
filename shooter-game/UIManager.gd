extends Control

@export var max_people: int = 5
@onready var notification_label: Label = $NotificationLabel
@onready var tween: Tween = _get_tween_node()
var people_healed: int = 0

func _get_tween_node() -> Tween:
	var tween_node = get_node("Tween")
	if not tween_node or not tween_node is Tween:
		push_error("Tween node not found or is not of type Tween")
		return Tween.new()
	return tween_node as Tween

func _ready():
	# Initialize label properties
	notification_label.modulate.a = 1.0
	notification_label.position = Vector2(10, 10)
	notification_label.text = "People Healed 0/5"
	
	# Connect signals from enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.healed_person.connect(_on_person_healed)
	
func _on_person_healed():
	people_healed += 1
	notification_label.text = "People Healed " + str(people_healed) + "/5"
