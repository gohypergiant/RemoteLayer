RemoteLayer = require "RemoteLayer"

############################################
# Example usage.
# For all features, please check the README.
############################################

myRemote = new RemoteLayer
	menuAction: -> print "menu"
	homeAction: -> print "home"
	playPauseAction: -> print "play/pause"
	clickAction: -> print "touchpad click"
	swipeUpAction: -> print "swipe up"
	swipeDownAction: -> print "swipe down"
	swipeLeftAction: -> print "swipe left"
	swipeRightAction: -> print "swipe right"
