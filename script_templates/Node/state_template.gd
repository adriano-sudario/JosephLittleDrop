extends State

# Condition to change to a specific state.
# Ex: if you have a state node called 'SnakeCaseStateName' on the same state machine,
# adding this method would make a connection with this state
# and make the transition to it if the condition is matched
func _snake_case_state_name_condition() -> bool:
	return true # Replace with condition.

# Called when the state has just been changed
func _enter():
	pass # Replace with function body.

# Called when the the state has just been exited
func _exit():
	pass # Replace with function body.

# Called every _proccess
func _update(_delta):
	pass # Replace with function body.

# Called every _proccess_physics
func _update_physics(_delta):
	pass # Replace with function body.
