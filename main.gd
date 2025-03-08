extends Node
@export var mob_scene : PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()
	$ScoreTimer.stop()
	$MobTimer.stop()
	
func new_game():
	#removes any remaining mobs 
	get_tree().call_group("mobs", "queue_free")
	#reset game state
	$Music.play()
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_mob_timer_timeout() -> void:
	#create new instance of mob
	var mob = mob_scene.instantiate()
	
	#choose random position on path
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	#spawn mob where spawner currently is (random)
	mob.position = mob_spawn_location.position
	
	#set mob direction to be perpendiuclar to the path
	var direction = mob_spawn_location.rotation + PI/2
	
	#add some randomness to direction
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	#random velocity with range
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0) #will rotate so y will change
	mob.linear_velocity = velocity.rotated(direction)
	
	#spawn mob by adding it to the scene
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
	$MobTimer.start()
