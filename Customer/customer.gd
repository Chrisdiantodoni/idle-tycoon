extends Node2D

class_name Customer

@onready var shadow: Sprite2D = %Shadow
@onready var body: Sprite2D = %Body
@onready var face: Sprite2D = %Face
@onready var hand_left: Sprite2D = %HandLeft
@onready var hand_right: Sprite2D = %HandRight
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var item_box: Control = $ItemBox
@onready var item_img: TextureRect = $ItemBox/TextureRect/ItemImg
@onready var item_label: Label = $ItemBox/TextureRect/ItemLabel

var request_item: Item
var request_qty: int
var current_order_status: int

func init_customer(item:Item, quantity:int) -> void:
	request_item = item
	request_qty = quantity
	current_order_status = quantity
	show_order_ui()

func set_sprites(data:CustomerData) -> void:
	body.texture = data.body
	face.texture = data.face
	hand_left.texture = data.hand
	hand_right.texture = data.hand
	pass
	
func show_order_ui():
	item_box.show()
	item_img.texture = request_item.sprite
	item_label.text = str(request_qty)
	pass
	
func play_move_anim() -> void:
	animation_player.play('move')
