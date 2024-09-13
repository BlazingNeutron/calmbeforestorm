class_name Scores extends Resource

@export var high_scores : Array = []

const SAVE_PATH:String = "res://highscore.tres"
	
func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)

func add(score:int) -> void:
	high_scores.push_back(score)
	high_scores.sort()

static func load() -> Scores:
	var res:Scores = null
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as Scores
	else:
		res = Scores.new()
	return res
