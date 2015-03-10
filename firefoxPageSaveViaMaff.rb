require "sikulix"
include Sikulix
Settings.ActionLogs = false
Settings.InfoLogs = false
Settings.MinSimilarity = 0.9
App.focus("firefox");
ImagePath.add("../images.sikuli")
s = Screen.new
p = Pattern("firefoxUrlTextField.png")
s.wait(p.similar(0.7), 2).click()
#s.click("firefoxUrlTextField.png")
s.type("a", KeyModifier.CMD)
s.type(Key.BACKSPACE)
s.paste(ARGV[0] + " ")
s.type(Key.ENTER)
sleep 2
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
p = Pattern("saveAsLabel.png")
saveAs = s.wait(p.similar(0.8), 4)
# saveAs = s.find("saveAsLabel.png")
saveAs.setTargetOffset(70, 0)
saveAs.click()
sleep 0.3
s.type("a", KeyModifier.CMD)
s.type(Key.BACKSPACE)
s.type("/")
s.type("a", KeyModifier.CMD)
s.paste(ARGV[1])
sleep 0.7	
s.type(Key.ENTER)
s.waitVanish("saveAsDialogWindowTitle.png", 2)
s.type(Key.ENTER)
p = Pattern("downloadFinished.png")
s.wait(p.similar(0.95), 10)
sleep 0.3

