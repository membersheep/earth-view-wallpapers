import Quick
import Nimble

class PreferencesManagerSpec: QuickSpec {
    override func spec() {
        describe("PreferencesManagerImpl") {
            var manager: PreferencesManager!
            var startupService = StartupServiceMock()
            var defaultsStore = UserDefaultsStoreMock()
            let managerDelegate = PreferencesManagerDelegate()
            
            beforeEach {
                startupService = StartupServiceMock()
                defaultsStore = UserDefaultsStoreMock()
                manager = PreferencesManagerImpl(startupService: startupService, userDefaultsManager: defaultsStore)
                manager.delegate = managerDelegate
            }
            
            describe("setStartAtLogin") {
                it("adds application to startup items through proper service") {
                    manager.setStartAtLogin(true)
                    
                    expect(startupService.applicationIsInStartUpItems()).to(equal(true))
                }
                it("removes application to startup items through proper service") {
                    manager.setStartAtLogin(false)
                    
                    expect(startupService.applicationIsInStartUpItems()).to(equal(false))
                }
            }
            
            describe("setUpdateInterval") {
                it("sets the update interval in deafaults store") {
                    manager.setUpdateInterval(.Week)
                    
                    expect(defaultsStore.getUpdateInterval()).to(equal(3600.0 * 24 * 7))
                }
                it("notifies the delegate") {
                    manager.setUpdateInterval(.Week)
                    
                    expect(managerDelegate.called).to(equal(true))
                }
            }
        }
    }
    
    
}

class StartupServiceMock: StartupService {
    var applicationInStartUpItems: Bool = true
    
    func applicationIsInStartUpItems() -> Bool {
        return applicationInStartUpItems
    }
    
    func addApplicationToStartupItems() {
        applicationInStartUpItems = true
    }
    
    func removeApplicationFromStartupItems() {
        applicationInStartUpItems = false
    }
    
    func toggleLaunchAtStartup() {
        applicationInStartUpItems = !applicationInStartUpItems
    }
}

class UserDefaultsStoreMock: UserDefaultsStore {
    var startAtLogin = true
    var updateInterval: Double = 0.0
    var lastUpdateDate: NSDate?
    
    func setStartAtLogin(value: Bool) {
        startAtLogin = value
    }
    func getStartAtLogin() -> Bool {
        return startAtLogin
    }
    func setUpdateInterval(value: Double) {
        updateInterval = value
    }
    func getUpdateInterval() ->  Double {
        return updateInterval
    }
    func setLastUpdateDate(date: NSDate?) {
        lastUpdateDate = date
    }
    func getLastUpdateDate() -> NSDate? {
        return lastUpdateDate
    }
}

class PreferencesManagerDelegate: PreferencesDelegate {
    var called = false
    func timeIntervalUpdated(interval: NSTimeInterval) {
        called = true
    }
}