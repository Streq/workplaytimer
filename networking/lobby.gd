extends Control
onready var host_panel = $"%host_panel"
onready var client_panel = $"%client_panel"
onready var disconnect = $"%disconnect"

var ip = "" setget set_ip

func set_ip(val):
	ip = val

func _ready():
	host_panel.connect("submit", self, "host")
	host_panel.connect("has_public_address", self, "set_ip")
	client_panel.connect("submit", self, "join")
	var tree : SceneTree = get_tree()
	tree.connect("network_peer_connected", self, "_on_network_peer_connected")
	tree.connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	
	# client-only signals
	tree.connect("connected_to_server", self, "_on_connected_to_server")
	tree.connect("server_disconnected", self, "_on_server_disconnected")
	tree.connect("connection_failed", self, "_on_connection_failed")

	disconnect.connect("pressed", self, "network_disconnect")

const SERVER_MESSAGE="""---
Server created, listening on port {port}.
Your [color=yellow]public address[/color] is [color=yellow]{public_address}[/color] (this one is the one people online need to join your server, you need to forward the port for this one to work).
Your [color=#ff00ff]local addresses[/color] (the ones people in the same network use to join your server) [color=#ff00ff]are[indent]{local_addresses}[/indent][/color]
---"""
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
	var local_addresses = "\n".join(IP.get_local_addresses())
	var public_address = ip.replace("\n","") if ip else "unresolved, you can try going to [url]https://icanhazip.com/[/url] to check it"
	Console.do_print(SERVER_MESSAGE.format({
			port=port, 
			public_address=public_address,
			local_addresses=local_addresses
		}))
	disconnect.disabled = false



func join(address:String, port:int):
	if validate_port(port):
		return
	Console.do_print("Creating client")
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_client(address, port)
	if error:
		Console.do_printerr("error - failed to create client, error code is %s - %s" % [error, ErrorUtils.get_error_text(error)])
		return
	get_tree().set_network_peer(peer)
	Console.do_print("Client created")
	Console.do_print("Attempting to connect to server on %s:%s" % [address,port])
func validate_port(port):
	if port<1024 or port>65535:
		Console.do_printerr("error - port must be a number between 1024 and 65535")
		return 1
	return 0

func _on_network_peer_connected(id):
	Console.do_print("Peer %s connected" % id)
func _on_network_peer_disconnected(id):
	Console.do_print("Peer %s disconnected" % id)

func _on_connected_to_server():
	Console.do_print("Connected to server")
	disconnect.disabled = false

func _on_server_disconnected():
	Console.do_print("Disconnected from server")
	disconnect.disabled = true

func _on_connection_failed():
	Console.do_printerr("Connection to server failed")
	disconnect.disabled = true

func network_disconnect():
	var tree = get_tree()
	if !tree.has_network_peer():
		return
	get_tree().network_peer = null
	disconnect.disabled = true
	Console.do_print("Disconnected from server")

