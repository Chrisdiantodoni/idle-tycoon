extends Node2D

class_name Cashier

signal on_order_completed(cashier: Cashier)

@export var move_speed := 50.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cook_bar: Control = $CookBar

var current_customer: Customer
var counter_pos: Vector2

var item_request: Item
var item_counter_pos: Vector2

func set_customer(customer: Customer) -> void:
	current_customer = customer
	customer.being_served = true
	counter_pos = Vector2(customer.position.x, customer.position.y + 160)
	item_request = customer.request_item
	item_counter_pos = GameManager.get_item_counter_pos(item_request)

func take_order() -> void:
	move_to_customer()
	await get_tree().create_timer(1.1).timeout
	current_customer.show_order_ui()
	move_to_item_position()
	pass

func move_to_customer() -> void:
	## create tween
	var tween:= create_tween()
	tween.tween_property(self, "position", counter_pos, 1.0)
	# move
	animation_player.play('move')

func move_to_item_position() -> void:
	animation_player.play('move')
	var tween:= create_tween()
	tween.tween_property(self, "position", item_counter_pos, 1.0)
	tween.tween_interval(0.5)
	tween.finished.connect(func(): start_cook_time())

func start_cook_time() -> void:
	animation_player.play('idle')
	cook_bar.show()
	cook_bar.cook_item(item_request.cook_time)
	
func deliver_order() -> void:
	move_to_customer()
	await get_tree().create_timer(1.1).timeout
	current_customer.receive_order()
	GameManager.current_coins += item_request.profit
	GameManager.play_coin_vfx(global_position)
	
	if not current_customer.current_order_status <= 0:
		move_to_item_position()
	else:
		animation_player.play("idle")
		current_customer = null
		on_order_completed.emit(self)


func _on_cook_bar_on_cook_completed() -> void:
	cook_bar.hide()
	cook_bar.reset_bar()
	deliver_order()
	pass # Replace with function body.
