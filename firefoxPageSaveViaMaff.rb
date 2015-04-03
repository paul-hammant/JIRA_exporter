require "sikulix"
include Sikulix
Settings.ActionLogs = false
Settings.InfoLogs = false
Settings.MinSimilarity = 0.9
App.focus("firefox");
ImagePath.add("../images.sikuli")
s = Screen.new
p = Pattern("backForwardButtons.png")
urlField = s.wait(p.similar(0.7), 3)
urlField.setTargetOffset(70, 0)
urlField.click()
s.type("a", KeyModifier.CMD)
s.type(Key.BACKSPACE)
s.paste(ARGV[0] + " ")
s.type(Key.ENTER)
sleep 2
# Wait for page to complete loading
p = Pattern("tabFullyLoaded.png")
s.wait(p.similar(0.8), 50).click()
# Expand activities, if needed
begin
  act = s.find("act.png")
  act.setTargetOffset(10, 0)
  act.click()
  sleep 1
rescue
end
# Make sure "All Activities" is clicked. May be redundant. May not be visible in the page. May not even be in the page.
begin
  all = s.find("activtyHeading.png")
  all.setTargetOffset(0, 40)
  all.click()
  sleep 1
rescue
end
s.click("fileMenu.png")
sleep 0.5
s.click("savePageAsArchive.png")
sleep 0.3
# Change download name and location
p = Pattern("saveAsLabel.png")
saveAs = s.wait(p.similar(0.8), 4)
saveAs.setTargetOffset(70, 0)
saveAs.click()
sleep 0.3
s.type("a", KeyModifier.CMD)
s.type(Key.BACKSPACE)
s.type("/")
s.type("a", KeyModifier.CMD)
s.paste(ARGV[1])
sleep 0.7	
# close popup form for the path
s.type(Key.ENTER)
s.waitVanish("goToFolderCaption.png", 10)
# enter should mean "Save" action happens for dialog
s.type(Key.ENTER)
s.waitVanish("saveAsDialogWindowTitle.png", 10)
# saves can take a while, especially for the main index page
p = Pattern("downloadFinished.png")
s.wait(p.similar(0.95), 30)
sleep 0.3

