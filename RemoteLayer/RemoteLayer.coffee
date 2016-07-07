'''
RemoteLayer module by Black Pixel, Inc.

Save this file to the /modules folder within your Framer project.
Add the following two lines to your project in Framer Studio:

RemoteLayer = require "RemoteLayer"
myRemote = new RemoteLayer

("myRemote" can be any name you like.)

PROPERTIES:
- align <string> ("left" || "center" || "right")
- margin <number>
- fromBottom <number>
- gloss <boolean>
- transition <string> ("fade" || "pop")
- hide <boolean>
- autoHide <boolean>
- highlightColor <string> (hex or rgba)

(Setting "autoHide" also implies "hide" -- no need to set both.)

SHOWING OR HIDING THE REMOTE:
myRemote.show()
myRemote.hide()

ALIGNING THE REMOTE:
myRemote.align(align, margin?, fromBottom?)

(Only useful if you wish to change the remote location some time after initialization.)

CHECK VISIBILITY:
myRemote.hidden (read only)

ASSIGN ACTIONS TO BUTTONS:
myRemote = new RemoteLayer
	menuAction: -> <action>
	homeAction: -> <action>
	micAction: -> <action>
	playPauseAction: -> <action>
	volumeUpAction: -> <action>
	volumeDownAction: -> <action>
	clickAction: -> <action>
	swipeUpAction: -> <action>
	swipeDownAction: -> <action>
	swipeLeftAction: -> <action>
	swipeRightAction: -> <action>

(In all cases, "myRemote" will be whatever name you supplied.)
'''

# commonly used border thickness
borderThickness = 2

noop = () ->

createCommonCircleButton = () ->
  new Layer
    width: 76
    height: 76
    borderRadius: 38
    style:
      background: '-webkit-linear-gradient(top, #999999, #1A1A1A)'
      boxShadow: '0 0 0 2pt rgba(0, 0, 0, 0.5)'

createCommonButtonInner = () ->
  new Layer
    x: 1
    y: 1
    width: 74
    height: 74
    borderRadius: 37
    backgroundColor: '#3D3D3D'

createBase = (parent) ->
  layer = new Layer
    width: 228
    height: 740
    backgroundColor: '#1A1A1A'
    style: background: '-webkit-linear-gradient(top, #404040, #333333)'
    borderRadius: 42
    shadowColor: '#808080'
    shadowBlur: 0
    shadowSpread: 2
    name: 'base'
    parent: parent
    clip: true

  layer.states.animationOptions = time: 0.5
  layer.states.add
    hide: opacity: 0
    show: opacity: 1
    up: y: 0
    down: y: Screen.height + borderThickness

  return layer

createTouchSurface = (parent) ->
  new Layer
    x: 0
    y: 0
    width: 228
    height: 322
    backgroundColor: 'gray'
    opacity: 0
    name: 'touchSurface'
    parent: parent

createInertSurface = (parent) ->
  new Layer
    x: 0
    y: 323
    width: 228
    height: 417
    style: background: '-webkit-linear-gradient(-60deg, #333333, #1A1A1A)'
    name: 'inertSurface'
    parent: parent

createGlossEffect = (parent) ->
  new Layer
    x: 0
    y: 323
    width: 228
    height: 417
    backgroundColor: 'transparent'
    html: '<svg width="228" height="417" viewBox="0 0 228 417"><defs><linearGradient id="a" x1="128" x2="128" y2="436.11" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="gray"/><stop offset=".72" stop-color="#1a1a1a"/></linearGradient></defs><path fill="url(#a)" d="M228 0H28l166.8 417H228V0"/></svg>'
    name: 'glossEffect'
    visible: false
    parent: parent

createGroove = (parent) ->
  new Layer
    x: 0
    y: 322
    width: 228
    height: 1
    backgroundColor: '#262626'
    name: 'groove'
    parent: parent

createGrooveHightlight = (parent) ->
  new Layer
    x: 0
    y: 323
    width: 228
    height: 1
    backgroundColor: '#595959'
    name: 'grooveHighlight'
    parent: parent

createMicSlot = (parent) ->
  new Layer
    x: 106
    y: 23
    width: 16
    height: 6
    backgroundColor: 'transparent'
    borderColor: '#141414'
    borderWidth: 2
    borderRadius: 3
    shadowX: 0
    shadowY: 1
    shadowColor: '#4D4D4D'
    name: "micSlot"
    parent: parent

createMenuButton = (parent) ->
  layer = createCommonCircleButton()
  layer.x = 25
  layer.y = 238
  layer.name = 'menuButton'
  layer.parent = parent
  return layer

createMenuButtonInner = (parent) ->
  layer = createCommonButtonInner()
  layer.name = 'menuButtonInner'
  layer.parent = parent
  layer.html = '<svg width="74" height="74" viewBox="0 0 74 74"><g fill="none" stroke="#d8d8d8" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path d="M25 42V32l-5 9.5-5-9.5v10M35 32h-6v10h6M39 42V32l8 10V32M35 37h-6M59 32v6a4 4 0 0 1-4 4 4 4 0 0 1-4-4v-6"/></g></svg>'
  return layer

createHomeButton = (parent) ->
  layer = createCommonCircleButton()
  layer.x = 127
  layer.y = 238
  layer.name = 'homeButton'
  layer.parent = parent
  return layer

createHomeButtonInner = (parent) ->
  layer = createCommonButtonInner()
  layer.name = 'homeButtonInner'
  layer.parent = parent
  layer.html = '<svg width="74" height="74" viewBox="0 0 74 74"><g fill="#d8d8d8"><path d="M48 29v13H24V29h24m0-2H24a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2h24a2 2 0 0 0 2-2V29a2 2 0 0 0-2-2z"/><rect x="31" y="46" width="10" height="2" rx="1" ry="1"/></g></svg>'
  return layer

createMicButton = (parent) ->
  layer = createCommonCircleButton()
  layer.x = 25
  layer.y = 334
  layer.name = 'micButton'
  layer.parent = parent
  return layer

createMicButtonInner = (parent) ->
  layer = createCommonButtonInner()
  layer.name = 'micButtonInner'
  layer.parent = parent
  layer.html = '<svg width="74" height="74" viewBox="0 0 74 74"><rect x="32" y="22" width="8" height="20" rx="4" ry="4" fill="#d8d8d8"/><rect x="30" y="48" width="12" height="2" rx="1" ry="1" fill="#d8d8d8"/><path d="M29 33v5a7 7 0 0 0 7 7 7 7 0 0 0 7-7v-5" fill="none" stroke="#d8d8d8" stroke-linecap="round" stroke-miterlimit="10" stroke-width="2"/><path fill="#d8d8d8" d="M35 45h2v3h-2z"/></svg>'
  return layer

createPlayPauseButton = (parent) ->
  layer = createCommonCircleButton()
  layer.x = 25
  layer.y = 430
  layer.name = 'playPauseButton'
  layer.parent = parent
  return layer

createPlayPauseButtonInner = (parent) ->
  layer = createCommonButtonInner()
  layer.name = 'playPauseButtonInner'
  layer.parent = parent
  layer.html = '<svg width="74" height="74" viewBox="0 0 74 74"><g fill="#d8d8d8"><rect x="42" y="30" width="3" height="13" rx="1.5" ry="1.5"/><rect x="48" y="30" width="3" height="13" rx="1.5" ry="1.5"/><path d="M25 30.29v12.42a1 1 0 0 0 1.52.85l10.09-6.21a1 1 0 0 0 0-1.7l-10.09-6.21a1 1 0 0 0-1.52.85z"/></g></svg>'
  return layer

createVolumeButton = (parent) ->
  new Layer
    x: 130
    y: 334
    width: 70
    height: 172
    borderRadius: 38
    style:
      background: '-webkit-linear-gradient(top, #999999, #1A1A1A)'
      boxShadow: '0 0 0 2pt rgba(0, 0, 0, 0.5)'
    name: 'volumeButton'
    parent: parent

createVolumeButtonInner = (parent) ->
  new Layer
    x: 1
    y: 1
    width: 68
    height: 170
    borderRadius: 37
    backgroundColor: '#3D3D3D'
    name: 'volumeButtonInner'
    parent: parent
    html: '<svg width="70" height="172" viewBox="0 0 70 172"><g fill="#d8d8d8"><rect x="25" y="36" width="20" height="2" rx="1" ry="1"/><rect x="25" y="36" width="20" height="2" rx="1" ry="1" transform="rotate(90 35 37)"/><rect x="24" y="132" width="20" height="2" rx="1" ry="1"/></g></svg>'

createVolumeButtonUp = (parent) ->
  new Layer
    width: 70
    height: 86
    backgroundColor: 'gray'
    opacity: 0
    name: 'volumeButtonUp'
    parent: parent

createVolumeButtonDown = (parent) ->
  new Layer
    y: 86
    width: 70
    height: 86
    backgroundColor: 'gray'
    opacity: 0
    name: 'volumeButtonDown'
    parent: parent

defaultOptions =
  gloss: false
  transition: 'fade'
  hide: false
  align: 'right'
  margin: 50
  fromBottom: 550
  autoHide: false
  backgroundColor: 'transparent'
  highlightColor: 'rgba(74, 144, 226, 0.5)'
  width: 228
  height: 740
  clip: false
  homeAction: noop
  menuAction: noop
  micAction: noop
  playPauseAction: noop
  volumeUpAction: noop
  volumeDownAction: noop
  clickAction: noop
  swipeUpAction: noop
  swipeDownAction: noop
  swipeLeftAction: noop
  swipeRightAction: noop

class RemoteLayer extends Layer
  @define 'hidden', get: () -> @_hidden
  @define 'transition', get: () -> @options.transition

  # initialization
  constructor: (options={}) ->
    @options = _.defaults options, defaultOptions
    @_hidden = @options.hide;
    super @options

    # base layer to contain all visual elements
    @base = createBase(@)

    # layer construction
    touchSurface = createTouchSurface(@base)
    inertSurface = createInertSurface(@base)
    glossEffect = createGlossEffect(@base)
    groove = createGroove(@base)
    grooveHighlight = createGrooveHightlight(@base)
    micSlot = createMicSlot(@base)
    menuButton = createMenuButton(@base)
    menuButtonInner = createMenuButtonInner(menuButton)
    homeButton = createHomeButton(@base)
    homeButtonInner = createHomeButtonInner(homeButton)
    micButton = createMicButton(@base)
    micButtonInner = createMicButtonInner(micButton)
    playPauseButton = createPlayPauseButton(@base)
    playPauseButtonInner = createPlayPauseButtonInner(playPauseButton)
    volumeButton = createVolumeButton(@base)
    volumeButtonInner = createVolumeButtonInner(volumeButton)
    volumeButtonUp = createVolumeButtonUp(volumeButton)
    volumeButtonDown = createVolumeButtonDown(volumeButton)

    # assign actions to buttons
    menuButton.onClick => @options.menuAction()
    homeButton.onClick => @options.homeAction()
    micButton.onClick => @options.micAction()
    playPauseButton.onClick => @options.playPauseAction()
    volumeButtonUp.onClick => @options.volumeUpAction()
    volumeButtonDown.onClick => @options.volumeDownAction()
    touchSurface.onClick => @options.clickAction()
    touchSurface.onSwipeUp => @options.swipeUpAction()
    touchSurface.onSwipeDown => @options.swipeDownAction()
    touchSurface.onSwipeLeft => @options.swipeLeftAction()
    touchSurface.onSwipeRight => @options.swipeRightAction()

    # show or hide gloss effects depending on user setting
    if @options.gloss
      glossEffect.visible = true
      inertSurface.style.background = ''
      inertSurface.backgroundColor = '#1A1A1A'

    # show/hide button area
    if @options.autoHide || @options.hide
      @_hidden = true
      @onMouseOver @showCautiously
      @onMouseOut @hideCautiously
      switch @transition
        when 'fade' then @base.states.switchInstant('hide')
        when 'pop' then @base.states.switchInstant('down')
        else return

    @align()

    # arrays of buttons for interaction states
    roundButtons = [menuButton, homeButton, micButton, playPauseButton, volumeButton]
    innerButtons = [menuButtonInner, homeButtonInner, micButtonInner, playPauseButtonInner]
    volumeButtons = [volumeButtonUp, volumeButtonDown]
    highlight = @options.highlightColor

    # button mouseover effects
    for button in roundButtons
      button.onMouseOver ->
        this.style =
          boxShadow: "0 0 0 2pt rgba(0, 0, 0, 0.5), 0 0 0 5pt #{highlight}"
      button.onMouseOut ->
        this.style =
          boxShadow: '0 0 0 2pt rgba(0, 0, 0, 0.5)'

    # button mousedown effects
    for button in innerButtons
      button.onMouseDown -> @brightness = 70
      button.onMouseUp -> @brightness = 100
      button.onMouseOut -> @brightness = 100

    for button in volumeButtons
      button.onMouseDown -> volumeButtonInner.brightness = 70
      button.onMouseUp -> volumeButtonInner.brightness = 100

  align: (align = @options.align, margin = @options.margin, fromBottom = @options.fromBottom) ->
    if align == 'left'
      @x = margin + borderThickness
      @y = Screen.height + borderThickness - fromBottom
    else if align == 'center'
      @centerX()
      @y = Screen.height + borderThickness - fromBottom
    else
      @x = Screen.width - @width - margin - borderThickness
      @y = Screen.height + borderThickness - fromBottom

  show: () ->
    @_hidden = false
    switch @transition
      when 'fade' then @base.states.switch('show')
      when 'pop' then @base.states.switch('up')
      else return

  hide: () ->
    @_hidden = true
    switch @transition
      when 'fade' then @base.states.switch('hide')
      when 'pop' then @base.states.switch('down')
      else return

  showCautiously: Utils.debounce 0.1, -> @show()
  hideCautiously: Utils.debounce 1.0, -> @hide()

module.exports = RemoteLayer
