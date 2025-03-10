extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var anim = get_node("AnimationPlayer")
var attacking = false

func _physics_process(delta: float) -> void:
	#Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
	if velocity.y > 0:
		anim.play("Fall")
		
	#Shooting
	#TODO make atk animation play out fully
	#TODO add projectile fireball animation
	if Input.is_action_just_pressed("attack"):
		attacking = true
		anim.play("Attack")
		attacking = false
	
	#Direction change
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	if direction and not attacking:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")	
	move_and_slide()

	if Game.playerHP <= 0:
		queue_free()
		Utils.resetGame()
		get_tree().change_scene_to_file("res://main.tscn")

#Variable jump height depending on the length the jump button is held for
func _input(event):
	if event.is_action_released("jump"):
		if velocity.y < 0:
			velocity.y *= 0.5
