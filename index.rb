require "sikulix"
include Sikulix
Settings.setShowActions(true)
ImagePath.add("images.sikuli")
s = Screen.new
s.click("1424575128978.png")
sleep 3
s.write("Hello World")
# popup 'hi', 'title'
