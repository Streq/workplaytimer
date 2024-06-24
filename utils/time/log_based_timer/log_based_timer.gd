extends Reference
class_name LogBasedTimer

var entries : PoolIntArray = PoolIntArray()
var _running := false
var _accum := 0

func clear():
	entries.resize(0)
	_running = false
	_accum = 0

func _update_running():
	_running = (entries.size() % 2) != 0
func is_running()->bool:
	return _running
func is_stopped()->bool:
	return !_running
	

func start_at(time_millis: int):
	if _running:
		return
	_start_at(time_millis)
func _start_at(time_millis: int):
	var size := entries.size()
	if size == 0:
		_running = true
		entries.append(time_millis)
		return
	
	var last := entries[size-1]
	if last > time_millis:
		return
	
	_running = true
	if last < time_millis:
		entries.append(time_millis)
		return
	
	_accum -= last - entries[size-2]
	entries.remove(size-1)

func stop_at(time_millis: int):
	if !_running:
		return
	_stop_at(time_millis)
func _stop_at(time_millis: int):
	var size := entries.size()
	var last := entries[size-1]

	if last > time_millis:
		return
	_running = false
	
	if last < time_millis:
		entries.append(time_millis)
		_accum += time_millis - last
		return
	
	entries.remove(size-1)

func toggle_at(time_millis: int):
	if _running:
		_stop_at(time_millis)
	else:
		_start_at(time_millis)

func start():
	start_at(TimeUtils.now_mil())

func stop():
	stop_at(TimeUtils.now_mil())

func toggle():
	toggle_at(TimeUtils.now_mil())

func get_time() -> int:
	return get_time_at(TimeUtils.now_mil())

func get_time_at(current_time: int) -> int:
	if is_stopped():
		return _accum
	return _accum + current_time - entries[entries.size()-1]

func insert_active_range(start: int, end: int):
	# empty interval
	if start == end:
		return
	
	# if inverted then flip
	if start > end:
		var aux := start
		start = end
		end = aux
	
	var size := entries.size()
	
	# if empty just insert
	if size == 0:
		entries.append(start)
		entries.append(end)
		_accum += end-start
		return

	var existing_start := entries[0]
	
	# if single entry modify it to earliest, ignore end since open interval
	if size == 1:
		entries[0] = MathUtils.mini(existing_start, start)
		return
	
	# if before beginning just insert
	if existing_start > end:
		entries.insert(0, start)
		entries.insert(1, end)
		_accum += end-start
		return
	
	# if after last and closed, insert, otherwise ignore since open interval
	var existing_end := entries[size-1]
	if existing_end < start:
		if _running:
			return
		entries.append(start)
		entries.append(end)
		_accum += end-start
		return

	# handle middle insertion
	var merged := 0
	for i in range(0, size-size%2, 2):
		var current_interval_start : int = entries[i]
		var current_interval_end : int = entries[i+1]
		
		#  '']  (..  ?
		if start > current_interval_end:
			continue
		
		#  (..___'']  

		#  (..) ['']?
		if end < current_interval_start:
			break
		
		#  (..[:)'']  
		#  [''(:)'']  
		#  (..[:]..)  
		#  [''(:]..)  
		start = MathUtils.mini(start, current_interval_start)
		entries[i] = start
		merged += 1
	
	for i in MathUtils.invert_range(0, size-size%2, 2):
		var current_interval_start : int = entries[i]
		var current_interval_end : int = entries[i+1]
		
		#  '']  (..  ?
		if start > current_interval_end:
			if merged == 0:
				entries.insert(i, start)
				entries.insert(i+1, end)
				_accum += end-start
				return
			break
		#  (..___'']
		
		#  (..) ['']?
		if end < current_interval_start:
			continue
		
		#  (..[:)'']  
		#  [''(:)'']  
		#  (..[:]..)  
		#  [''(:]..)  
		merged += 1
		end = MathUtils.maxi(end, current_interval_end)
		entries[i+1] = end
	
	var open_ended := false
	if _running and existing_end <= end:
		merged += 1
		open_ended = true
		entries[entries.size()-1] = end
	
	if merged == 0:
		return
	
	clean_duplicates()
	
	if open_ended:
		entries.remove(entries.size()-1)
	
	_full_recalc()


func remove_active_range(start: int, end: int):
	# empty interval
	if start == end:
		return

	var size := entries.size()
	
	# if empty do nothing
	if size == 0:
		return

	# if inverted then flip
	if start > end:
		var aux := start
		start = end
		end = aux

	var existing_start := entries[0]
	
	# if before beginning do nothing
	if existing_start > end:
		return
	
	# if single entry
	if size == 1:
		if existing_start >= start:
			entries[0] = MathUtils.maxi(existing_start, end)
			return
		entries.append(start)
		entries.append(end)
		_accum = start - existing_start
		return
	
	
	var existing_end := entries[size-1]
	if existing_end <= start:
		if !_running:
			return
		if existing_end == start:
			entries[size-1] = MathUtils.maxi(existing_end, end)
			return
		entries.append(start)
		entries.append(end)
		_accum += start-existing_end
		return
	if existing_end < end and _running:
		entries[size-1] = end

	# handle middle removal
	var deleted := 0
	for i in range(0, size - (size%2), 2):
		var current_interval_start : int = entries[i]
		var current_interval_end : int = entries[i+1]
		
		#   [''] (..)  ?
		if start > current_interval_end:
			continue
		
		# __(..___'']__

		#   (..) ['']  ?
		if end < current_interval_start:
			break
		
		if current_interval_start < start:
		# ['(::___'']__
			if end < current_interval_end:
		# ['(::)'''']  
				entries.insert(i+1, end)
				entries.insert(i+1, start)
				_accum -= end-start
				break
		# ['(:::::::].)
			entries[i+1] = start
			_accum -= current_interval_end - start
			continue
		#   (..[__'']__
		if end < current_interval_end:
		#   (..[:)'']  
			entries[i] = end
			_accum -= end - current_interval_start
			break
			
		
		#   (..[::::].)
		entries[i] = FOR_REMOVAL
		entries[i+1] = FOR_REMOVAL
		_accum -= current_interval_end-current_interval_start
		deleted += 1
		
	if deleted > 0:
		clean_for_removal()

const FOR_REMOVAL := -1
func clean_for_removal():
	for i in range(entries.size()-1, -1, -1):
		if entries[i] == FOR_REMOVAL:
			entries.remove(i)
		
const NOT_FOUND := -1
func clean_duplicates():
	var i = entries.size() - 1
	while i > 0:
		var dupe = entries.rfind(entries[i], i-1)
		if dupe != NOT_FOUND:
			entries.remove(dupe)
		i -= 1
	
func _full_recalc():
	_accum = 0
	for i in range(0, entries.size()-1, 2):
		_accum += entries[i+1] - entries[i]
	
	
