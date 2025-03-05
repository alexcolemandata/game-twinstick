extends StaticBody2D

var player: CharacterBody2D
var spawn_path: PathFollow2D
const ENEMY = preload("res://Enemy.tscn")

func _ready() -> void:
	spawn_path = %SpawnPath
	

func _on_spawn_timer_timeout() -> void:
	var roll = randf()
	if roll < 0.5:
		return
	$SpawnTimer.wait_time = roll * (1 + randf())
	spawn_enemy()
	
func _process(_delta: float) -> void:
	%PhysicsBox.polygon = $Polygon2D.polygon
	


func spawn_enemy() -> void:
	var enemy = ENEMY.instantiate()
	spawn_path.progress_ratio = randf()
	enemy.player = %Player
	add_child(enemy)
	enemy.global_position = spawn_path.global_position
	$AnimationPlayer.play("Spawn")
