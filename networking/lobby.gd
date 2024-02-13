extends Control
onready var host_panel = $"%host_panel"
onready var client_panel = $"%client_panel"

func _ready():
	host_panel.connect("submit", self, "host")
	client_panel.connect("submit", self, "join")
	var tree : SceneTree = get_tree()
	tree.connect("network_peer_connected", self, "_on_network_peer_connected")
	tree.connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	
	# client-only signals
	tree.connect("connected_to_server", self, "_on_connected_to_server")
	tree.connect("server_disconnected", self, "_on_server_disconnected")
	tree.connect("connection_failed", self, "_on_connection_failed")

func host(port: int):
	if validate_port(port):
		return
	Console.do_print("Creating server on port %s" % port)
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_server(port)
	if error:
		Console.do_printerr("error - failed to create server, error code is %s - %s" % [error, ErrorUtils.get_error_text(error)])
		return
	get_tree().set_network_peer(peer)
	Console.do_print("Server created, listening on port %s, local addresses are: \n\t%s" % [port, "\n\t".join(IP.get_local_addresses())])


func join(address:String, port:int):
	if validate_port(port):
		return
	Console.do_print("Attempting to connect to server on %s:%s" % [address,port])
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_client(address, port)
	if error:
		Console.do_printerr("error - failed to create client, error code is %s - %s" % [error, ErrorUtils.get_error_text(error)])
		return
	get_tree().set_network_peer(peer)
	Console.do_print("Client created")

func validate_port(port):
	if port<1024 or port>65535:
		Console.do_printerr("error - port must be a number between 1024 and 65535")
		return 1
	return 0

func _on_network_peer_connected(id):
	Console.do_print("peer %s connected" % id)
func _on_network_peer_disconnected(id):
	Console.do_print("peer %s disconnected" % id)
func _on_connected_to_server():
	Console.do_print("connected to server")
func _on_server_disconnected():
	Console.do_print("disconnected from server")
func _on_connection_failed():
	Console.do_printerr("connection to server failed")
