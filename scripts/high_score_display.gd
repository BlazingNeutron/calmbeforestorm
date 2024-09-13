extends Control

signal close_score

func _on_visibility_changed() -> void:
	var high_scores = Scores.load()
	var scores = high_scores.high_scores
	if scores.is_empty():
		$VBoxContainer/NoScoresYet.show()
	else:
		$VBoxContainer/NoScoresYet.hide()
		scores.sort()
		scores.reverse()
		var count = 1
		for score in scores:
			get_node("VBoxContainer/Score" + str(count)).text = str(count) + ". " + str(score)
			count += 1
			if count > 10:
				break

func _on_back_button_pressed() -> void:
	close_score.emit()
