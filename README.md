### RemoteLayer Framer Module

The RemoteLayer module allows you to instantly generate an interactive Apple TV remote for your tvOS app prototypes. You can choose your preferred styling, alignment, animation and button highlight color. All buttons (and swipes on the touchpad) can be configured to perform your own supplied actions.

<img src="https://cloud.githubusercontent.com/assets/935/16821270/e57262d6-491a-11e6-82ee-e1db13fe6522.png" width="497" style="display: block; margin: auto" alt="RemoteLayer preview" />

Save the RemoteLayer.coffee file to the /modules folder within your Framer project.
Add the following two lines to your Framer project:

```javascript
RemoteLayer = require "RemoteLayer"
myRemote = new RemoteLayer
```

(“myRemote” can be any name you like.)

### Properties:

Set any of these by indenting once below the `new RemoteLayer` line, like so:

```
myRemote = new RemoteLayer
    gloss: true
```
- align \<string> ("left" || "center" || "right")
- margin \<number>
- fromBottom \<number>
- gloss \<boolean>
- transition \<string> ("fade" || "pop")
- hide \<boolean>
- autoHide \<boolean>
- highlightColor \<string> (hex or rgba)

(Setting "autoHide" also implies "hide" -- no need to set both.)

### Showing or Hiding the Remote:
- `myRemote.show()`
- `myRemote.hide()`

### Aligning the Remote:
- `myRemote.align(align, margin?, fromBottom?)`

(Only useful if you wish to change the remote location some time after initialization.)

### Check Visibility:
- `myRemote.hidden` \<boolean> (read only)

### Assign Actions to Buttons:
```javascript
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

(In all cases, "myRemote" will be whatever name you supplied.)

---

Website: [blackpixel.com](https://blackpixel.com) &nbsp;&middot;&nbsp;
GitHub: [@bpxl-labs](https://github.com/bpxl-labs/) &nbsp;&middot;&nbsp;
Twitter: [@blackpixel](https://twitter.com/blackpixel) &nbsp;&middot;&nbsp;
Medium: [@bpxl-craft](https://medium.com/bpxl-craft)
