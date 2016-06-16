
How to add ModMenu entries for your mod (or someone else's)

First you must define an array for the structure of your menu.  Bare minimum you must define the values frame and text.  Frame is used to detect if your mod is loaded, text is what is shown in the menu.  You must also define one, and only one, value for the behavior of your root menu item.  Acceptable options are toggle, cmd, and func.  Their behaviors are described below.

Submenus can hold any commands that the root level can.  There is also a blank line option.  You are limit to 32 items in a submenu.

text -- this variable is the menu text for your item, must always be defined.
frame -- root level only, used to detect the mod is loaded
cat -- The category menu the mad should be placed in (Default "other" if undefined)
loc -- if defined the entry will only load on the specified locale's client (ex: deDE)
toggle -- frame to toggle visibility
func -- function to call (does not pass arguments)
cmd -- a text slash command to send, like "/console reloadui"
submenu -- an array consisting on menu item arrays
TITAN_MODMENU_SPACER -- use this to crate an empty entry, not valid in the root level

After you have created your menu array, call this function in your mod's onLoad.  You should also add an optional dependancy for MM so that MM loads first.

TitanPanelModMenu_RegisterMenu("ModName", menuarray);

ModName is used for sort order in the menu.

If you are writing the menu for a mod that is not your own, please submit it to the comment section on curse gaming and I will hard-code it into the mod so everyone can use it.

A number of common strings are included in the localization file, you are encouraged to use them ^^  Loc options for menu items will be added soon to selectivly display options for some multi-lingual addons
