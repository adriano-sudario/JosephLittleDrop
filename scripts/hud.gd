extends CanvasLayer

func _ready():
	visible = false
	var player:Player = $"../Player"
	player.on_little_drop_collected.connect(_on_little_drop_collected)

func _on_little_drop_collected(coins):
	$Coins.text = str(coins)
