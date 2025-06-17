extends Node

signal on_customer_request(customer: Customer)
signal on_customer_order_completed(customer: Customer)

const ITEM_BURGER = preload("res://data/Item_burger.tres")
const ITEM_COFFEE = preload("res://data/item_coffee.tres")
const COIN_VFX = preload("res://VFX/coin_vfx.tscn")

var coffee_item_counter_pos := Vector2(415,1250)
var burger_item_counter_pos := Vector2(665,1250)
var current_coins:int 

func play_coin_vfx(spawn_pos: Vector2) -> void:
	var instance: GPUParticles2D = COIN_VFX.instantiate()
	get_tree().root.add_child(instance)
	var new_position := Vector2(spawn_pos.x, spawn_pos.y - 60)
	instance.global_position = new_position
	instance.emitting = true
	instance.finished.connect(func(): instance.queue_free())

func get_random_item() -> Item:
	var items: Array = [ITEM_BURGER, ITEM_COFFEE]
	return items.pick_random()

func get_item_counter_pos(item: Item) -> Vector2:
	match item.type:
		Item.ItemType.Coffee:
			return coffee_item_counter_pos
		Item.ItemType.Burger:
			return burger_item_counter_pos
	return Vector2.ZERO
