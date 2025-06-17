extends Node

class_name CustomerManager

@export var spawn_positions: Array[Marker2D]
@export var customer_sprites: Array[CustomerData]
@export var customer_scene: PackedScene
@onready var counter_manager: CounterManager = %CounterManager

func _ready() -> void:
	spawn_customer()

func spawn_customer()-> void:
	var customer: Customer = customer_scene.instantiate()
	add_child(customer)
	
	## get random sprites
	var sprite_data: CustomerData = customer_sprites.pick_random()
	var random_item: Item = GameManager.get_random_item()
	
	customer.set_sprites(sprite_data)
	customer.init_customer(random_item, randi_range(1, 3))
	
	if counter_manager.get_free_index() != -1:
		customer.position = spawn_positions[1].position
		counter_manager.assign_customer(customer)
		customer.move_to_counter()
	else: 
		# Get Random Spawn Position
		var random_start_pos: Marker2D = spawn_positions.pick_random()
		customer.position = random_start_pos.position
		customer.play_move_anim()
		# move the customer
		var tween: Tween = create_tween()
		tween.tween_property(customer, "position", customer.position + Vector2.RIGHT * 1350, 5.0)
		tween.finished.connect(func(): customer.queue_free())
	
	
	


func _on_spawn_timer_timeout() -> void:
	spawn_customer()
