import Foundation
import Quick
import Nimble

@testable import SchoolProject

class SchoolProjectTests: QuickSpec {
    override func spec() {
        describe("testing") {
            it("bool") {
            let someBool =  false
            expect(someBool).to(beFalse())
            }
        }
    }
}
