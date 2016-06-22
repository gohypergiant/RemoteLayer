'''
RemoteLayer module by Black Pixel, Inc.

Save this file to the /modules folder within your Framer project.
Add the following two lines to your project in Framer Studio:

{RemoteLayer} = require "RemoteLayer"
myRemote = new RemoteLayer

("myRemote" can be any name you like.)

PROPERTIES:
- align <string> ("left" || "center" || "right")
- margin <number>
- fromBottom <number>
- gloss <boolean> 
- transition <string> ("fade" || "pop")
- hidden <boolean>
- autoHide <boolean>
- highlightColor <string> (hex or rgba)

(Setting "autoHide" also implies "hidden" -- no need to set both.)

SHOWING OR HIDING THE REMOTE:
myRemote.show()
myRemote.hide()

ALIGNING THE REMOTE:
myRemote.align(align, margin?, fromBottom?)

(Only useful if you wish to change the remote location some time after initialization.)

CHECK VISIBILITY:
myRemote.hidden (read only)

ASSIGN ACTIONS TO BUTTONS:
myRemote.menuAction = -> <action>
myRemote.homeAction = -> <action>
myRemote.micAction = -> <action>
myRemote.playPauseAction = -> <action>
myRemote.volumeUpAction = -> <action>
myRemote.volumeDownAction = -> <action>
myRemote.clickAction = -> <action>
myRemote.swipeUpAction = -> <action>
myRemote.swipeDownAction = -> <action>
myRemote.swipeLeftAction = -> <action>
myRemote.swipeRightAction = -> <action>

(In all cases, "myRemote" will be whatever name you supplied.)

'''

class exports.RemoteLayer extends Layer
	# initialization
	constructor: (@options={}) ->
		
		# exposing button actions for user customization
		@menuAction = @menuAction?()
		@homeAction = @homeAction?()
		@micAction = @micAction?()
		@playPauseAction = @playPauseAction?()
		@volumeUpAction = @volumeUpAction?()
		@volumeDownAction = @volumeDownAction?()
		@clickAction = @clickAction?()
		@swipeUpAction = @swipeUpAction?()
		@swipeDownAction = @swipeDownAction?()
		@swipeLeftAction = @swipeLeftAction?()
		@swipeRightAction = @swipeRightAction?()
		
		# creating the base layer, with exposed options for gloss and hide style
		@options = _.defaults @options,
			@options.gloss ?= false
			@options.transition ?= "fade"
			@options.hidden ?= false
			@options.align ?= "right"
			@options.margin ?= 50
			@options.fromBottom ?= 550
			@options.autoHide ?= false
			@options.highlightColor ?= "rgba(74, 144, 226, 0.5)"
			backgroundColor: "clear"
			width: 228
			height: 740
			clip: false
		
		super @options
		
		# global references
		exports.hidden = @options.hidden
		exports.transition = @options.transition
		exports.autoHide = @options.autoHide
		
		# module variables
		borderThickness = 2
		highlightColor = @options.highlightColor
		
		# base layer to contain all visual elements
		base = new Layer
			width: 228
			height: 740
			backgroundColor: "#1A1A1A"
			style: background: "-webkit-linear-gradient(top, hsl(0,0%,25%), hsl(0,0%,20%))"
			borderRadius: 42
			shadowColor: "hsl(0, 0%, 50%)"
			shadowBlur: 0
			shadowSpread: 2
			name: "base"
			parent: @
			clip: true
			
		base.states.add	
			hide:
				opacity: 0
			show:
				opacity: 1
			up:
				y: 0
			down:
				y: Screen.height + borderThickness
				
		base.states.animationOptions = time: 0.5
		
		# module methods
		@align = (align = @options.align, margin = @options.margin, fromBottom = @options.fromBottom) ->
			if align == "left"
				@.x = margin + borderThickness
				@.y = Screen.height + borderThickness - fromBottom
			else if align == "center"
				@.centerX()
				@.y = Screen.height + borderThickness - fromBottom
			else #right alignment
				@.x = Screen.width - @.width - margin - borderThickness
				@.y = Screen.height + borderThickness - fromBottom
				
		@_initialize = ->
			if exports.autoHide == true
				@options.hidden = exports.hidden = true
			@align(@options.align, @options.margin, @options.fromBottom)
			if exports.hidden == true
				if exports.transition == "fade"
					base.states.switchInstant("hide")
					@options.hidden = exports.hidden = true
				else if exports.transition == "pop"
					base.states.switchInstant("down")
					@options.hidden = exports.hidden = true
				else
					return

		exports.show = @show = () ->
			if exports.hidden == true
				if exports.transition == "fade"
					base.states.switch("show")
					@options.hidden = exports.hidden = false
				else if exports.transition == "pop"
					base.states.switch("up")
					@options.hidden = exports.hidden = false
				else
					return
		
		exports.hide = @hide = () ->
			if exports.hidden == false
				if exports.transition == "fade"
					@options.hidden = exports.hidden = true
					base.states.switch("hide")
				else if exports.transition == "pop"
					@options.hidden = exports.hidden = true
					base.states.switch("down")
				else
					return
		
		@showCautiously = Utils.debounce 0.1, =>
			@show()
			
		@hideCautiously = Utils.debounce 1.0, =>
			@hide()
				
		@_initialize()
	
		
		# show/hide button area
		if exports.autoHide == true
			@.onMouseOver -> 
				@showCautiously()
			@.onMouseOut -> 
				@hideCautiously()
		
		# layer construction
			
		touchSurface = new Layer
			x: 0
			y: 0
			width: 228
			height: 322
			backgroundColor: "gray"
			opacity: 0
			name: "touchSurface"
			parent: base

		inertSurface = new Layer
			x: 0
			y: 323
			width: 228
			height: 417
			style: background: "-webkit-linear-gradient(-60deg, hsl(0,0%,20%),hsl(0,0%,10%))"
			name: "inertSurface"
			parent: base
			
		glossEffect = new Layer
			x: 0
			y: 323
			width: 228
			height: 417
			backgroundColor: "clear"
			html: '<svg width="228" height="417" viewBox="0 0 228 417"> <defs> <linearGradient id="linear-gradient" x1="128" x2="128" y2="436.11" gradientUnits="userSpaceOnUse"> <stop offset="0" stop-color="gray"/> <stop offset="0.72" stop-color="#1a1a1a"/> </linearGradient> </defs> <polygon points="228 0 28 0 194.8 417 228 417 228 0" fill="url(#linear-gradient)"/> </svg>'
			name: "glossEffect"
			visible: false
			parent: base
		
		# show or hide gloss effects depending on user setting
		if @options.gloss is true
			glossEffect.visible = true
			inertSurface.style.background = ""
			inertSurface.backgroundColor = "#1A1A1A"
	
		groove = new Layer
			x: 0
			y: 322
			width: 228
			height: 1
			backgroundColor: "hsl(0, 0%, 15%)"
			name: "groove"
			parent: base
	
		grooveHighlight = new Layer
			x: 0
			y: 323
			width: 228
			height: 1
			backgroundColor: "hsl(0, 0%, 35%)"
			name: "grooveHighlight"
			parent: base
	
		micSlot = new Layer
			x: 106
			y: 23
			width: 16
			height: 6
			backgroundColor: "clear"
			borderColor: "hsl(0, 0%, 8%)"
			borderWidth: 2
			borderRadius: 3
			shadowX: 0
			shadowY: 1
			shadowColor: "hsl(0, 0%, 30%)"
			name: "micSlot"
			parent: base
				
		# buttons
	
		menuButton = new Layer
			x: 25
			y: 238
			width: 76
			height: 76
			borderRadius: 38
			style: 
				background: "-webkit-linear-gradient(top, hsl(0,0%,60%),hsl(0,0%,10%))"
				boxShadow: "0 0 0 2pt rgba(0, 0, 0, 0.5)"
			name: "menuButton"
			parent: base

		menuButtonInner = new Layer
			x: 1
			y: 1
			width: 74
			height: 74
			borderRadius: 37
			backgroundColor: "hsl(0, 0%, 24%)"
			name: "menuButtonInner"
			parent: menuButton
			html: '<svg width="74" height="74" viewBox="0 0 74 74"> <g id="menuGlyph"> <polyline points="25 42 25 32 20 41.5 15 32 15 42" fill="none" stroke="#d8d8d8" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/> <polyline points="35 32 29 32 29 42 35 42" fill="none" stroke="#d8d8d8" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/> <polyline points="39 42 39 32 47 42 47 32" fill="none" stroke="#d8d8d8" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/> <line x1="35" y1="37" x2="29" y2="37" fill="none" stroke="#d8d8d8" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/> <path d="M59,32v6a4,4,0,0,1-4,4h0a4,4,0,0,1-4-4V32" fill="none" stroke="#d8d8d8" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/> </g> </svg>'
	
		homeButton = new Layer
			x: 127
			y: 238
			width: 76
			height: 76
			borderRadius: 38
			style: 
				background: "-webkit-linear-gradient(top, hsl(0,0%,60%),hsl(0,0%,10%))"
				boxShadow: "0 0 0 2pt rgba(0, 0, 0, 0.5)"
			name: "homeButton"
			parent: base
	
		homeButtonInner = new Layer
			x: 1
			y: 1
			width: 74
			height: 74
			borderRadius: 37
			backgroundColor: "hsl(0, 0%, 24%)"
			name: "homeButtonInner"
			parent: homeButton
			html: '<svg width="74" height="74" viewBox="0 0 74 74"> <g id="homeGlyph"> <path d="M48,29V42H24V29H48m0-2H24a2,2,0,0,0-2,2V42a2,2,0,0,0,2,2H48a2,2,0,0,0,2-2V29a2,2,0,0,0-2-2h0Z" fill="#d8d8d8"/> <rect x="31" y="46" width="10" height="2" rx="1" ry="1" fill="#d8d8d8"/> </g> </svg>'
	
		micButton = new Layer
			x: 25
			y: 334
			width: 76
			height: 76
			borderRadius: 38
			style: 
				background: "-webkit-linear-gradient(top, hsl(0,0%,60%),hsl(0,0%,10%))"
				boxShadow: "0 0 0 2pt rgba(0, 0, 0, 0.5)"
			name: "micButton"
			parent: base
	
		micButtonInner = new Layer
			x: 1
			y: 1
			width: 74
			height: 74
			borderRadius: 37
			backgroundColor: "hsl(0, 0%, 24%)"
			name: "micButtonInner"
			parent: micButton
			html: '<svg width="74" height="74" viewBox="0 0 74 74"> <g id="micGlyph"> <rect x="32" y="22" width="8" height="20" rx="4" ry="4" fill="#d8d8d8"/> <rect x="30" y="48" width="12" height="2" rx="1" ry="1" fill="#d8d8d8"/> <path d="M29,33v5a7,7,0,0,0,7,7h0a7,7,0,0,0,7-7V33" fill="none" stroke="#d8d8d8" stroke-linecap="round" stroke-miterlimit="10" stroke-width="2"/> <rect x="35" y="45" width="2" height="3" fill="#d8d8d8"/> </g> </svg>'
	
		playPauseButton = new Layer
			x: 25
			y: 430
			width: 76
			height: 76
			borderRadius: 38
			style: 
				background: "-webkit-linear-gradient(top, hsl(0,0%,60%),hsl(0,0%,10%))"
				boxShadow: "0 0 0 2pt rgba(0, 0, 0, 0.5)"
			name: "playPauseButton"
			parent: base
	
		playPauseButtonInner = new Layer
			x: 1
			y: 1
			width: 74
			height: 74
			borderRadius: 37
			backgroundColor: "hsl(0, 0%, 24%)"
			name: "playPauseButtonInner"
			parent: playPauseButton
			html: '<svg width="74" height="74" viewBox="0 0 74 74"> <g id="playPause"> <g id="playPauseGlyph"> <rect x="42" y="30" width="3" height="13" rx="1.5" ry="1.5" fill="#d8d8d8"/> <rect x="48" y="30" width="3" height="13" rx="1.5" ry="1.5" fill="#d8d8d8"/> <path d="M25,30.29V42.71a1,1,0,0,0,1.52.85l10.09-6.21a1,1,0,0,0,0-1.7L26.52,29.44A1,1,0,0,0,25,30.29Z" fill="#d8d8d8"/> </g> </g> </svg>'
	
		volumeButton = new Layer
			x: 130
			y: 334
			width: 70
			height: 172
			borderRadius: 38
			style: 
				background: "-webkit-linear-gradient(top, hsl(0,0%,60%),hsl(0,0%,10%))"
				boxShadow: "0 0 0 2pt rgba(0, 0, 0, 0.5)"
			name: "volumeButton"
			parent: base
		
		volumeButtonInner = new Layer
			x: 1
			y: 1
			width: 68
			height: 170
			borderRadius: 37
			backgroundColor: "hsl(0, 0%, 24%)"
			name: "volumeButtonInner"
			parent: volumeButton
			html: '<svg width="70" height="172" viewBox="0 0 70 172"> <g id="volume"> <g id="volumeGlyph"> <rect x="25" y="36" width="20" height="2" rx="1" ry="1" fill="#d8d8d8"/> <rect x="25" y="36" width="20" height="2" rx="1" ry="1" transform="translate(72 2) rotate(90)" fill="#d8d8d8"/> <rect x="24" y="132" width="20" height="2" rx="1" ry="1" fill="#d8d8d8"/> </g> </g> </svg>'
			
		volumeButtonUp = new Layer
			width: 70
			height: 86
			backgroundColor: "gray"
			opacity: 0
			name: "volumeButtonUp"
			parent: volumeButton
		
		volumeButtonDown = new Layer
			parent: volumeButton
			y: 86
			width: 70
			height: 86
			backgroundColor: "gray"
			opacity: 0
			name: "volumeButtonDown"
			parent: volumeButton
		
		
		# arrays of buttons for interaction states
		roundButtons = [menuButton, homeButton, micButton, playPauseButton, volumeButton]
		innerButtons = [menuButtonInner, homeButtonInner, micButtonInner, playPauseButtonInner]
		volumeButtons = [volumeButtonUp, volumeButtonDown]
		
		# button mouseover effects
		for button in roundButtons
			button.onMouseOver ->
				this.style = 
					"background": "-webkit-linear-gradient(top, hsl(0,0%,60%),hsl(0,0%,10%))"
					"boxShadow": "0 0 0 2pt rgba(0, 0, 0, 0.5), 0 0 0 5pt #{highlightColor}"
			button.onMouseOut ->
				this.style = 
					"background": "-webkit-linear-gradient(top, hsl(0,0%,60%),hsl(0,0%,10%))"
					"boxShadow": "0 0 0 2pt rgba(0, 0, 0, 0.5)"
		
		# button mousedown effects
		for button in innerButtons
			button.onMouseDown ->
				this.brightness = 70
			button.onMouseUp ->
				this.brightness = 100
			button.onMouseOut ->
				this.brightness = 100
		
		for button in volumeButtons
			button.onMouseDown ->
				volumeButtonInner.brightness = 70
			button.onMouseUp ->
				volumeButtonInner.brightness = 100
		
		# assign user-defined actions to buttons
		menuButton.onClick => @menuAction?()
		homeButton.onClick => @homeAction?()
		micButton.onClick => @micAction?()
		playPauseButton.onClick => @playPauseAction?()
		volumeButtonUp.onClick => @volumeUpAction?()
		volumeButtonDown.onClick => @volumeDownAction?()
		touchSurface.onClick => @clickAction?()
		touchSurface.onSwipeUp => @swipeUpAction?()
		touchSurface.onSwipeDown => @swipeDownAction?()
		touchSurface.onSwipeLeft => @swipeLeftAction?()
		touchSurface.onSwipeRight => @swipeRightAction?()
		
	@define 'hidden',
		get: -> 
			@options.hidden
		set: (value) -> 
			# @options.hidden = value
