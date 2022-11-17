tool
extends Node

const card_hover = "card_hover"

var subscribers = {}
var one_time_buffer = {}
	
func publish(key, parameters = null):
	if Engine.editor_hint:
		return
	if subscribers.empty() || !subscribers.has(key):
		if not one_time_buffer.has(key):
			one_time_buffer[key] = []
		one_time_buffer[key].append(parameters)
		return
	var target_subscribers = subscribers[key]
	if not target_subscribers is Array || target_subscribers.empty():
		return
	var erase_members = []
	for subscriber in target_subscribers:
		if !is_instance_valid(subscriber.target):
			erase_members.append(subscriber)
		elif subscriber.target.is_queued_for_deletion():
			erase_members.append(subscriber)
		else:
			if parameters == null || (parameters is Array && parameters.empty()):
				subscriber.method.call_func()
			else:
				subscriber.method.call_func(parameters)
	for e in erase_members:
		subscribers[key].erase(e)

func subscribe(key,target,method:FuncRef):
	if Engine.editor_hint:
		return
	if !subscribers.has(key) || not subscribers[key] is Array:
		subscribers[key] = []
	var target_subscribers = subscribers[key]
	if !target_subscribers.empty():
		for subscriber in target_subscribers:
			if subscriber.target == target:
				return
	subscribers[key].append({"target":target,"method":method})
	if one_time_buffer.has(key) and not one_time_buffer[key].empty():
		for i in one_time_buffer[key]:
			publish(key,i)
		one_time_buffer[key].clear()
		one_time_buffer.erase(key)

func unsubscribe(key,target):
	if Engine.editor_hint:
		return
	if !subscribers.has(key) || not subscribers[key] is Array:
		return
	var target_subscribers = subscribers[key]
	if target_subscribers.empty():
		return
	for subscriber in target_subscribers:
		if subscriber.target == target:
			subscribers[key].erase(subscriber)
