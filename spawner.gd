extends StaticBody2D

var player: CharacterBody2D
var spawn_path: PathFollow2D
const ENEMY = preload("res://Enemy.tscn")

func _ready() -> void:
	spawn_path = %SpawnPath
	

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()


func spawn_enemy() -> void:
	var enemy = ENEMY.instantiate()
	spawn_path.progress_ratio = randf()
	enemy.player = %Player
	add_child(enemy)
	enemy.global_position = spawn_path.global_position


	pass # Replace with function body.
