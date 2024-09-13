extends Node2D

@onready var picker_uppers_container: Node2D = %PickerUppersContainer

var trash_array : Array = []
var beach_trash_array : Array = []
var picker_upper_array : Array = []

func _ready() -> void:
	GameManager.purchase_store_item.connect(adopt_picker_upper)

func _on_waste_spawner_spawned_trash(new_trash) -> void:
	#print("spawned trash ", new_trash.position.x)
	new_trash.landed.connect(_on_trash_landed)
	new_trash.picked_up.connect(_on_trash_picked_up)
	trash_array.push_front(new_trash)

func _on_trash_landed(new_beach_trash) -> void:
	#print("Trash landed", position)
	beach_trash_array.push_front(new_beach_trash)
	GameManager.update_health(beach_trash_array.size())

func _on_trash_picked_up(removed_trash) -> void:
	#print("a trash was picked up")
	if removed_trash.picker_upper != null:
		removed_trash.picker_upper.unassign()
	var trash_index = trash_array.find(removed_trash)
	if trash_index > -1:
		#print("trash removed")
		trash_array.remove_at(trash_index)
	
	var beach_trash_index = beach_trash_array.find(removed_trash)
	if beach_trash_index > -1:
		#print("beach trash removed")
		beach_trash_array.remove_at(beach_trash_index)
	GameManager.credit_account()
	GameManager.update_health(beach_trash_array.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	randomize()
	picker_upper_array.shuffle()
	for pu in picker_upper_array:
		var closest_trash = null
		#	print("evaluating trash")
		if pu.assigned == false:
			if pu.is_beach_bound:
				#print("searching for beach bound")
				closest_trash = search_for_beach_trash(pu)
			elif pu.is_water_bound:
				#print("searching for beach bound")
				closest_trash = search_for_water_trash(pu)
		if closest_trash != null:
			#print("found trash for a pu")
			pu.assign_trash(closest_trash)
			closest_trash.claimed = true
			closest_trash.picker_upper = pu

func search_for_beach_trash(pu : Node2D) -> Node2D:
	var current_pu_position = pu.global_position
	var shortest_distance = 10000
	var closest_trash = null
	for trash in beach_trash_array:
		#print("Look at this mess")
		if trash == null or trash.claimed == true:
			continue
		var trash_pos = trash.global_position
		var distance = current_pu_position.distance_to(trash_pos)
		if distance < shortest_distance:
			#print("found a close beach garbage for staff", trash.position)
			shortest_distance = distance
			closest_trash = trash
	return closest_trash

func search_for_water_trash(pu : Node2D) -> Node2D:
	var current_pu_position = pu.global_position
	var shortest_distance = 10000
	var closest_trash = null
	for trash in trash_array:
		#print("Look at this mess - ocean styles")
		if trash == null or trash.claimed == true or trash.has_landed or trash.position.y < -250 or trash.position.y > 110:
			continue
		var trash_pos = trash.global_position
		var distance = current_pu_position.distance_to(trash_pos)
		if distance < shortest_distance:
			#print("found a close garbage for boat", trash.position)
			shortest_distance = distance
			closest_trash = trash
	return closest_trash

func adopt_picker_upper(store_item_name : String) -> void:
	#print("adding picker upper")
	var store_item = GameManager.store_items.get(store_item_name)
	var new_picker_upper = store_item.scene.instantiate()
	new_picker_upper.position = new_picker_upper.spawn_position()
	picker_uppers_container.add_child(new_picker_upper)
	picker_upper_array.push_front(new_picker_upper)
