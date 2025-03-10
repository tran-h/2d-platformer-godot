extends CharacterBody2D

var SPEED = 60
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var frog
var chase = false

func _ready():
	frog = get_node("AnimatedSprite2D")
	frog.play("Idle")

func _physics_process(delta):
	#Gravity for Frog
	velocity.y += gravity * delta
	if chase == true:
		if frog.animation != "Death":
			frog.play("Jump")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			frog.flip_h = true
		else:
			frog.flip_h = false
		velocity.x = direction.x * SPEED
	else:
		if frog.animation != "Death":
			frog.play("Idle")
		velocity.x = 0
	move_and_slide()
	
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false
#TODO fix hp loss and pt gain on collision since 2 collision shapes are so close and linger
func _on_player_death_body_entered(body):
	if body.name == "Player":
		get_node("CollisionShape2D").disabled = true
		death()
		Utils.saveGame()

func _on_player_collision_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Game.playerHP -= 3
		Utils.saveGame()

func death():
	Game.points += 5
	chase = false
	frog.play("Death")
	frog.animation_finished.connect(queue_free)
