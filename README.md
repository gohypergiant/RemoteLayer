# RemoteLayer Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

<a href="https://open.framermodules.com/mapboxlayer"><img alt="Install with Framer Modules" src="https://www.framermodules.com/assets/badge@2x.png" width='160' height='40' /></a>

The RemoteLayer module allows you to instantly generate an interactive Apple TV remote for your tvOS app prototypes. You can choose your preferred styling, alignment, animation and button highlight color. All buttons (and swipes on the touchpad) can be configured to perform your own supplied actions.

<img src="https://cloud.githubusercontent.com/assets/935/16821270/e57262d6-491a-11e6-82ee-e1db13fe6522.png" width="497" style="display: block; margin: auto" alt="RemoteLayer preview" />

### Installation

#### NPM Installation

```
$ cd /your/framer/project
$ npm i @blackpixel/framer-remotelayer
```

#### Manual Installation

Copy / save the `RemoteLayer.coffee` file into your project's `modules` folder.

### Adding It To Your Project

In your Framer project add the following:

```javascript
// If you manually installed
RemoteLayer = require 'RemoteLayer'
// Else
RemoteLayer = require '@blackpixel/framer-remotelayer'

myRemote = new RemoteLayer
```

### Assigning Actions to Buttons

```coffeescript
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
```

### API

#### `new RemoteLayer`

Instantiates a new instance of RemoteLayer.

**Available options**

```coffeescript
myRemote = new RemoteLayer
	align: <string> ("left" || "center" || "right")
	margin: <number>
	fromBottom: <number>
	gloss: <boolean>
	transition: <string> ("fade" || "pop")
	hide: <boolean>
	autoHide: <boolean>
	highlightColor: <string> (hex or rgba)
```

_Setting `autoHide` implicitly sets `hide` to true._

**Returns**

`Layer` _(Object)_: A newly instantiated Framer Layer.

#### `myRemote.show()`

Show the RemoteLayer instance.

#### `myRemote.hide()`

Hide the RemoteLayer instance.

#### `myRemote.align(align, margin, fromBottom)`

Useful if you wish to change the remote location some time after initialization.

**Arguments**

1. `align` _(String)_: One of ("left" || "center" || "right")
2. `margin` _(Number)_: Layer margin value
3. `fromBottom` _(Number)_: Distance from bottom of screen

#### `myRemote.hidden`

> readonly

**Returns**

_(Boolean)_: Whether or not the RemoteLayer is currently hidden

---

Website: [blackpixel.com](https://blackpixel.com) &nbsp;&middot;&nbsp;
GitHub: [@bpxl-labs](https://github.com/bpxl-labs/) &nbsp;&middot;&nbsp;
Twitter: [@blackpixel](https://twitter.com/blackpixel) &nbsp;&middot;&nbsp;
Medium: [@bpxl-craft](https://medium.com/bpxl-craft)
