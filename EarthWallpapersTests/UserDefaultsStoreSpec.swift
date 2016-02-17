import Quick
import Nimble


class UserDefaultsStoreSpec: QuickSpec {
    
    func resetDefaults() {
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
    }
    
    override func spec() {
        describe("UserDefaultsStore") {
            var store: UserDefaultsStoreImpl!
            beforeEach {
                store = UserDefaultsStoreImpl()
                self.resetDefaults()
            }
            describe("setStartAtLogin") {
                it("saves true value in user defaults") {
                    store.setStartAtLogin(true)
                    
                    expect(store.getStartAtLogin()).to(equal(true))
                }
                it("saves false value in user defaults") {
                    store.setStartAtLogin(false)
                    
                    expect(store.getStartAtLogin()).to(equal(false))
                }
            }
        }
    }
}
