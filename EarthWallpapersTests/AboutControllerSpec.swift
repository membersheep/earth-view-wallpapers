import Quick
import Nimble

class AboutControllerSpec: QuickSpec {
    override func spec() {
        describe("AboutController") {
            var controller : AboutController!
            beforeEach {
                controller = AboutController()
            }
//            it("is a NSWindowController") {
//                expect(controller is NSWindowController).to(equal(true))
//            }
            describe("windowNibName") {
                it("has correct name") {
                    expect(controller.windowNibName).to(equal("AboutWindow"))
                }
            }
        }
    }
}
