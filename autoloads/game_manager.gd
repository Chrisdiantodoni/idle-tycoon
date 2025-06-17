extends Node


const ITEM_BURGER = preload("res://data/Item_burger.tres")
const ITEM_COFFEE = preload("res://data/item_coffee.tres")

func get_random_item() -> Item:
	var items: Array = [ITEM_BURGER, ITEM_COFFEE]
	return items.pick_random()
	
