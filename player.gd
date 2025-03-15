extends Area2D

#load and score pellet scene
@export var pellet_scene : PackedScene #= load("res://pellet.tscn")
signal hit

@export var speed = 400
var screen_size

#shoot pellet to left by default
var pellet_velocity = Vector2(400,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	if(Input.is_action_pressed("move_right")):
		velocity.x += 1
	if(Input.is_action_pressed("move_left")):
		velocity.x -= 1
	if(Input.is_action_pressed("move_down")):
		velocity.y += 1
	if(Input.is_action_pressed("move_up")):
		velocity.y -= 1
	if(Input.is_action_pressed("shoot")):
		#if cooldown expired and player isn't hidden (isn't dead)
		if ($cooldown.time_left == 0 && is_visible_in_tree()):
			$cooldown.start()
			shoot()

	if(velocity.length() > 0):
		velocity = velocity.normalized() * speed
		#send pellet in the direction player last moved.
		pellet_velocity = velocity
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		#make animation upright.
		$AnimatedSprite2D.flip_v = false
		#if moving left flip horizontally animation
		$AnimatedSprite2D.flip_h = velocity.x < 0 
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func shoot():
	var new_pellet = pellet_scene.instantiate()
	var pellet_position = position
	
	#set position and velocity of pellet
	new_pellet.position = pellet_position
	new_pellet.linear_velocity = pellet_velocity
	
	#parent is main scene.
	#if we add to player then position is messed up.
	get_parent().add_child(new_pellet)

func start(pos):
	position = pos
	#show player
	show()
	#safe to active collision
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	#player disappears when hit
	hide()
	hit.emit()
	#so hit isn't detected multiple times
	#set deferred means disable when safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)
