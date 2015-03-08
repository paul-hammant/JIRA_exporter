require "sikulix"
include Sikulix
Settings.setShowActions(true)
App.focus("firefox");
ImagePath.add("images.sikuli")
s = Screen.new
s.click("firefoxUrlTextField.png")
s.paste(ARGV[1]);
s.type(Key.ENTER);
# popup 'hi', 'title'
