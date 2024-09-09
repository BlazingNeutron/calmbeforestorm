extends Node2D

var trash_array : Array = []
var beach_trash_array : Array = []

func _on_waste_spawner_spawned_trash(new_trash) -> void:
	#print("spawned trash ", new_trash.position.x)
	new_trash.landed.connect(_on_trash_landed)
	new_trash.picked_up.connect(_on_trash_picked_up)
	trash_array.push_front(new_trash)

func _on_trash_landed(new_beach_trash) -> void:
	#print("Trash landed", position)
	beach_trash_array.push_front(new_beach_trash)

func _on_trash_picked_up(removed_trash) -> void:
	var trash_index = trash_array.find(removed_trash)
	if trash_index > -1:
		#print("trash removed")
		trash_array.remove_at(trash_index)
	var beach_trash_index = beach_trash_array.find(removed_trash)
	if beach_trash_index > -1:
		#print("beach trash removed")
		beach_trash_array.remove_at(beach_trash_index)
