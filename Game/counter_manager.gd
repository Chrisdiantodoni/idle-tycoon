extends Node
class_name CounterManager

@export var counter_positions: Array[Marker2D]

var counter: Dictionary[int, Customer] = {
	0:null, 
	1:null, 
	2:null, 
	3:null, 
}

func _ready() -> void:
	GameManager.on_customer_order_completed.connect(_on_customer_order_completed)

func get_free_index() -> int:
	for key in counter:
		if counter[key] == null:
			return key
	return -1

func assign_customer(customer: Customer) -> void:
	var index: int = get_free_index()
	if index == -1:
		return
	counter[index] = customer
	var free_counter_pos: Vector2 = counter_positions[index].position
	customer.counter_pos = free_counter_pos
	
func get_first_available_customer() -> Customer:
	var candidates := []
	for customer: Customer in counter.values():
		if customer != null and customer.waiting_order and not customer.being_served:
			candidates.append(customer)

	if candidates.size() == 0:
		return null

	# Urutkan berdasarkan waktu masuk atau urutan
	candidates.sort_custom(func(a, b): return a.entered_time < b.entered_time)
	return candidates[0]


func _on_customer_order_completed(customer: Customer) -> void:
	for index: int in counter:
		if counter[index] == customer:
			counter[index] = null
	
