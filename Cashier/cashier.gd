extends Node2D

class_name Cashier

@export var move_speed := 50.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func move_to_customer() -> void:
	## create tween
	# move
	animation_player.play('move')

func move_to_item_position() -> void:
	## create tween
	## move to item counter pos
	## start cook time
	animation_player.play('idle')
