extends Control


func _physics_process(delta: float) -> void:
	$SoulLabel.text = str(PlayerStats.souls)
	$ScrapLabel.text = str(PlayerStats.scrap)
