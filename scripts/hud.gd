extends CanvasLayer

func _on_coin_collected(coins):
	
	$Coins.text = str(coins)


func _on_texture_button_pressed() -> void:
	print("Mobile pressed!")
