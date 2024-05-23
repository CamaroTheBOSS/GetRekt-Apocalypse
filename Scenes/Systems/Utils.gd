extends Node
class_name Utils

static func signalExist(node: Node2D, signalString: String):
	return node.get_signal_list()[0]["name"] == signalString
