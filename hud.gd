extends CanvasLayer

#notifies main that the start button has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func update_score(score):
	$ScoreLabel.text = str(score)

func show_game_over():
	show_message("Game Over")
	
	#wait until timer has counted down
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	#create one shot timer and wait for it to timeout
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
