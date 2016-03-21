import Quick
import Nimble

class PreferencesControllerSpec: QuickSpec {
    override func spec() {
        describe("PreferencesController") {
            var controller: PreferencesController!
            var manager: PreferencesManager!
            beforeEach {
                manager = PreferencesManagerMock()
                controller = PreferencesController(manager: manager)
            }
            describe("windowNibName") {
                it("has correct name") {
                    expect(controller.windowNibName).to(equal("PreferencesWindow"))
                }
            }
            describe("windowDidLoad") {
                it("sets correct initial values in combo box") {
                    manager.setUpdateInterval(.Week)
                    manager.setStartAtLogin(false)
                    
                    controller.showWindow(self)
                    
                    expect(controller.timeComboBox.stringValue).to(equal(TimeInterval.Week.rawValue))
                    expect(controller.startupCheckBox.state).to(equal(0))
                }
            }
            describe("checkBoxClicked") {
                it("sets the value in the preferences manager") {
                    controller.showWindow(self)
                    controller.startupCheckBox.state = NSOnState
                    
                    controller.checkBoxClicked(controller.startupCheckBox)
                    
                    expect(manager.getStartAtLogin()).to(equal(true))
                }
            }
            describe("comboBoxSelectionDidChange") {
                it("sets the value in the preferences manager") {
                    controller.showWindow(self)
                    
                    controller.comboBoxSelectionDidChange(NSNotification(name: "testNotification", object: controller.timeComboBox))
                    
                    expect(manager.getUpdateInterval().rawValue).to(equal(controller.timeComboBox.objectValueOfSelectedItem as? String))
                }
            }
        }
    }
}

class PreferencesManagerMock: PreferencesManager {
    var delegate: PreferencesDelegate?
    var startAtLogin: Bool = true
    var timeInterval: TimeInterval = .Never
    
    func getStartAtLogin() -> Bool {
        return startAtLogin
    }
    
    func setStartAtLogin(value: Bool) {
        startAtLogin = value
    }
    
    func getUpdateInterval() -> TimeInterval {
        return timeInterval
    }
    func setUpdateInterval(interval: TimeInterval) {
        timeInterval = interval
    }
    
    
}