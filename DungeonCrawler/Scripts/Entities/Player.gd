extends KinematicBody2D

export var moveSpeed = 200

var rayCast
var state
var stateNew
var animation
var sprite

func _ready():
	set_fixed_process(true)
	rayCast = get_node("RayCast2D")
	animation = get_node("Sprite/Animation")
	sprite = get_node("Sprite")
	
func _fixed_process(delta):
	var motion = Vector2(0, 0)
	state = "idle"
	
	if(Input.is_action_pressed("ui_up")):
		motion += Vector2(0, -1)
		rayCast.set_rotd(180)
		state = "up"
		
	if(Input.is_action_pressed("ui_down")):
		motion += Vector2(0, 1)
		rayCast.set_rotd(0)
		state = "down"
		
	if(Input.is_action_pressed("ui_left")):
		motion += Vector2(-1, 0)
		rayCast.set_rotd(270)
		state = "left"
		
	if(Input.is_action_pressed("ui_right")):
		motion += Vector2(1, 0)
		rayCast.set_rotd(90)
		state = "right"
	
	if(Input.is_action_pressed("ui_select")):
		state = "attack"
		
	motion = motion * moveSpeed * delta 
	move(motion)
	
	update_sprite()
	
	if(is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move(motion)

func update_sprite():
	var anim = "Idle"
	
	if(state == "idle"):
		#TODO
		animation.stop()
		if(rayCast.get_rotd() == 0):
			anim = "Player_Idle_Down"
			
		elif(rayCast.get_rotd() == 180):
			anim = "Player_Idle_Up"
			
		elif(rayCast.get_rotd() == 90):
			anim = "Player_Idle_Right"
			sprite.set_flip_h(true)
			
		elif(rayCast.get_rotd() == 270):
			anim = "Player_Idle_Left"
			sprite.set_flip_h(false)
		
	elif(state == "right"):
		anim = "Player_Walking_Side"
		sprite.set_flip_h(true)
		
	elif(state == "up"):
		anim = "Player_Walking_Up"
		
	elif(state == "down"):
		anim = "Player_Walking_Down"
		
	elif(state == "left"):
		anim = "Player_Walking_Side"
		sprite.set_flip_h(false)
	
	elif(state == "attack"):
		#TODO
		animation.stop()
		if(rayCast.get_rotd() == 0):
			anim = "Player_Attack_Down"
			
		elif(rayCast.get_rotd() == 180):
			anim = "Player_Attack_Up"
			
		elif(rayCast.get_rotd() == 90):
			anim = "Player_Attack_Right"
			sprite.set_flip_h(true)
			
		elif(rayCast.get_rotd() == 270):
			anim = "Player_Attack_Left"
			sprite.set_flip_h(false)
			
	if(stateNew != state):
		stateNew = state
		animation.play(anim)