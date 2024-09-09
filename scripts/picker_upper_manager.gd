extends Node2D

var trash_array : Array = []
var beach_trash_array : Array = []
var picker_upper_array : Array = []

func _on_waste_spawner_spawned_trash(new_trash) -> void:
	#print("spawned trash ", new_trash.position.x)
	new_trash.landed.connect(_on_trash_landed)
	new_trash.picked_up.connect(_on_trash_picked_up)
	trash_array.push_front(new_trash)

func _on_trash_landed(new_beach_trash) -> void:
	print("Trash landed", position)
	beach_trash_array.push_front(new_beach_trash)

func _on_trash_picked_up(removed_trash) -> void:
	var trash_index = trash_array.find(removed_trash)
	if trash_index > -1:
		#print("trash removed")
		trash_array.remove_at(trash_index)
	var beach_trash_index = beach_trash_array.find(removed_trash)
	if beach_trash_index > -1:
		print("beach trash removed")
		beach_trash_array.remove_at(beach_trash_index)

func _on_picker_upper_adopted(picker_upper) -> void:
	print("picker upper added", picker_upper)
	picker_upper_array.push_front(picker_upper)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for pu in picker_upper_array:
		var current_pu_position = pu.global_position
		if pu.is_beach_bound:
			var shortest_distance = 10000
			var closest_trash = null
			for trash in beach_trash_array:
				var trash_pos = trash.global_position
				var distance = current_pu_position.distance_to(trash_pos)
				if distance < shortest_distance:
					#print("found a close beach garbage for volunteer", trash.position)
					shortest_distance = distance
					closest_trash = trash
			if closest_trash != null:
				#print("found beach garbage for volunteer")
				pu.position = pu.position.move_toward(closest_trash.position, delta * pu.speed)
				pu.move_and_slide()
