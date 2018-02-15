# plugin-apex-jet-ojselectcombobox

APEX version: 5.1
JET version: 2.0.2

Settings:
  Component Type: ojSelect or ojCombobox
  Placeholder: [type any text you want]

After initialization the plugin can be accessed via JavaScript:

widget.ojet.ojselectcombobox
  create: Initialization function for the plugin. You should not need this.
  info: Information about the plugin.
  items: List with all the apex items the plugin created. Via this object the list content can be dynamically changed.
  version: Version information.
  
The value of the item can be manupilated via the usual apex item interface. It can also be enabled or disabled via this interface.

i.e.
  apex.item('P5_NEW').getValue();
  apex.item('P5_NEW').setValue('PRESIDENT');
  apex.item('P5_NEW').enable();
  apex.item('P5_NEW').disable();
  
