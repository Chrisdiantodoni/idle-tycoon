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

var counter_pos: Vector2
var waiting_order: bool
var being_served: bool
var entered_time: float = Time.get_ticks_msec()
func _process(delta: float) -> void:
	item_label.text = str(current_order_status)

func init_customer(item:Item, quantity:int) -> void:
	request_item = item
	request_qty = quantity
	current_order_status = quantity

func move_to_counter()->void:
	play_move_anim()
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(counter_pos.x, position.y), 2.0)
	tween.tween_interval(0.2)
	tween.tween_property(self, "position", counter_pos, 1.0)
	tween.tween_interval(0.5)
	tween.finished.connect(func(): 
		animation_player.play("idle")
		waiting_order = true
		GameManager.on_customer_request.emit(self)
	)
	
func receive_order() -> void:
	current_order_status -= 1
	if current_order_status <= 0:
		order_completed()

func order_completed() -> void:
	item_box.hide()
	waiting_order = false
	var counter_top_pos: float = counter_pos.y - 150
	var tween := create_tween()
	var final_pos := Vector2(counter_pos.x, counter_top_pos)
	tween.tween_property(self, "position", final_pos, 1.0)
	tween.tween_interval(0.2)
	var end_pos := Vector2(counter_pos.x + 800, counter_top_pos)
	tween.tween_property(self, "position", end_pos, 3.0)
	tween.tween_interval(0.2)
	tween.finished.connect(func(): 
		GameManager.on_customer_order_completed.emit(self)
		self.queue_free()
	)
	

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
