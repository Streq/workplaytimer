extends PanelContainer
signal submit(port)

signal has_public_address()

onready var address_input = $"%address"
onready var port_input = $"%port"
onready var submit = $"%submit"
onready var http_request = $"%HTTPRequest"
const GET_IP_URL = "https://icanhazip.com"
const MAX_TRIES = 10
var tries = MAX_TRIES

func _ready():
	submit.connect("pressed", self, "_submit")
	address_input.value = "[unresolved]"

	http_request.connect("request_completed", self, "_on_ip_request_completed")
	retrieve_ip()


func _submit():
	var port = port_input.value.to_int()
	emit_signal("submit", port)

	

const http_response_format = """
result: {result}
response_code: {response_code}
headers: {headers}
body: {body}
"""
static func format_response(result, response_code, headers, body):
	return http_response_format.format({
			result = result,
			response_code = response_code,
			headers = "\n"+ "\n".join(headers),
			body = body
		})

func _on_ip_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	var body_str = body.get_string_from_utf8()
	var response = format_response(result, response_code, headers, body_str)
	if result or response_code != 200:
		printerr("Attempt to retrieve public IP from %s completed abnormally:%s" % [GET_IP_URL, response.replace("\n","\n\t")])
		if tries:
			address_input.value = "[failed to retrieve, retrying...]"
			print("Retrying in 5 seconds, %s %s left..." % [tries, "try" if tries == 1 else "tries"])
			tries -= 1
			get_tree().create_timer(5.0).connect("timeout", self, "retrieve_ip")
		else:
			address_input.value = "[unresolved]"
			print("No longer trying to retrieve public IP, limit reached (%s tries)." % MAX_TRIES)
			
	else:
		print("Attempt to retrieve external IP completed successfully:%s" % response.replace("\n","\n\t"))
		print("Your external IP is %s" % body_str)
		address_input.value = body_str
		emit_signal("has_public_address", body_str)
	
func retrieve_ip():
	print("Attempting to retrieve public IP...")
	address_input.value = "[retriving...]"
	http_request.request(GET_IP_URL)
