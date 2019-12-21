import XCTest
@testable import DXNetworkManager

final class DXNetworkManagerTests: XCTestCase {
    func testDirectExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let expect = self.expectation(description: "Fetching")
        
        var response: String = ""
        
        let request = DirectRequest(urlString: "https://danitoxserver.ddns.net", requireRawResponse: true)
        let manager = NetworkAgent<String>()
        manager.rawResponseGetter = { str in
            print(str)
            response = str
            expect.fulfill()
        }
        
        manager.executeNetworkRequest(with: request)
            
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(response.isEmpty == false)
        
    }

    static var allTests = [
        ("testExample", testDirectExample),
    ]
}
