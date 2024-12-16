extends Node
	
var socket: WebSocketPeer
var isOpen = false
var connect_id
signal callback(event:String, x:float, y:float)

func _ready():
	set_process(false)
	
func _process(_delta):
	# Call this in _process or _physics_process. Data transfer and state updates
	# will only happen when calling this function.
	socket.poll()
	
	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var json = JSON.new()
			var err = json.parse(socket.get_packet().get_string_from_utf8())
			if err != OK:
				push_error(err)
			var parsed = json.data;
			if isOpen:
				callback.emit(parsed["e"], parsed["x"], parsed["y"])
	elif state == WebSocketPeer.STATE_CLOSING:
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		isOpen = false
		set_process(false) # Stop processing.
	elif state == WebSocketPeer.STATE_CONNECTING:
		pass
		

func _connect_svr(result, code, headers, body) -> void:
	var json = JSON.new()
	var err = json.parse(body.get_string_from_utf8())
	if err != OK:
		push_error(err)
		
	connect_id = json.data["id"]
	print(connect_id)
	
	socket = WebSocketPeer.new()
	err = socket.connect_to_url("wss://demo.mansuiki.com/ws/game/" + connect_id)
	if err != OK:
		print(err)
		push_error(err)
	set_process(true)
	print("connected")

func start_imu() -> void:
	isOpen = true
	

func connect_svr() -> void:
	var req = HTTPRequest.new();
	add_child(req)
	req.request_completed.connect(self._connect_svr);
	var err = req.request("https://demo.mansuiki.com/ws/new");
	if err != OK:
		push_error("failed to connect server");
	
func close_connect() -> void:
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		socket.close()
