extends Node2D

const EnemyInitializer = preload("res://Scenes/EnemyInitializer.tscn")
const BossInitializer = preload("res://Scenes/BossInitializer.tscn")

onready var health = 150

var EnemyPath = Path2D.new()
var EnemySpawnLocation = PathFollow2D.new()

var enemy_spawned = 0

const Player = preload("res://Scenes/Player.tscn")

var enemy = EnemyInitializer.instance()
var boss = BossInitializer.instance()

func _ready():
	#Не удалять в этом месте будет подгрузка Json
	#Save.load_data()
	
	get_node("Health_bar").health_setup(health)
	
	$Background_move.play("Background_move")
	
	get_node("/root/SoundHandler").get_child(0).stop()
	
	get_tree().set_quit_on_go_back(false)
	randomize()
	var player = Player.instance()
	add_child(player)
	add_child(EnemyPath)
	EnemyPath.add_child(EnemySpawnLocation)
	EnemyPath.curve.add_point(Vector2(50,-10))
	EnemyPath.curve.add_point(Vector2(get_viewport().get_visible_rect().size.x - 50,-10))
	$StaticBody2D/Wall_left.global_position = Vector2(-5, $StaticBody2D/Wall_left.global_position.y)
	$StaticBody2D/Wall_right.global_position = Vector2(get_viewport().get_visible_rect().size.x + 5, $StaticBody2D/Wall_left.global_position.y)
	$EnemySpawnTimer.start()
	
	add_child(enemy)
	add_child(boss)
	pass 

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		get_tree().change_scene("res://Scenes/StartGame.tscn")

func _on_EnemySpawnTimer_timeout():
	if(get_node_or_null("Player")==null):return
	if (boss.get_child_count()==0):
		randomize()
		var situation=0
		if(enemy_spawned>10): situation = rand_range(0, 4)
		else: situation = rand_range(0, 3)
		if (situation<=1):
			enemy_spawned+=1
			EnemySpawnLocation.set_offset(randi())
			enemy.initialize("Enemy0", EnemySpawnLocation.position)
		elif (situation<=2):
			enemy_spawned+=1
			EnemySpawnLocation.set_offset(randi())
			enemy.initialize("Enemy1", EnemySpawnLocation.position)
		elif (situation<=3):
			enemy_spawned+=1
			EnemySpawnLocation.set_offset(randi())
			enemy.initialize("Enemy2", EnemySpawnLocation.position)
		elif (situation<=4):
			EnemySpawnLocation.set_offset(randi())
			boss.initialize("Hive", Vector2(get_viewport().get_visible_rect().size.x/2, 40))
			enemy_spawned=0
		pass
