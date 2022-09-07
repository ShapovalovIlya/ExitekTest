import Foundation
import XCTest

//MARK: - Test module
class PlaygroundTestObserver : NSObject, XCTestObservation {
    @objc private func testCase(testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: UInt) {
        print("Test failed on line \(lineNumber): \(testCase.name), \(description)")
    }
}

let observer = PlaygroundTestObserver()
let center = XCTestObservationCenter.shared
center.addTestObserver(observer)

struct TestRunner {
    public init() {}
    
    func runTests(testClass: AnyClass) {
        print("Running test suite \(testClass)")

        let tests = testClass as! XCTestCase.Type
        let testSuite = tests.defaultTestSuite
        testSuite.run()
        let run = testSuite.testRun as! XCTestSuiteRun

        print("Ran \(run.executionCount) tests in \(run.testDuration)s with \(run.totalFailureCount) failures")
    }
}

//MARK: - Test task
// Implement mobile phone storage protocol
// Requirements:
// - Mobiles must be unique (IMEI is an unique number)
// - Mobiles must be stored in memory

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

struct Mobile: Hashable {
    let imei: String
    let model: String
}

//MARK: - Mobile Controller class
final class MobileController: MobileStorage {
    
    var mobileStorage: Set<Mobile> = []
    
    enum MobileError: Error {
        case alreadyExists
        case notFound
    }
    // .getAll() method start
    func getAll() -> Set<Mobile> {
        return mobileStorage
    }
    
    // .fundByImei() method start
    func findByImei(_ imei: String) -> Mobile? {
        
        for mobile in mobileStorage {
            if mobile.imei == imei {
                return mobile
            } else {
                return nil
            }
        }
        return nil
    } // .getAll() method end
    
    func save(_ mobile: Mobile) throws -> Mobile {
        // Chek storage for duplicate
        if mobileStorage.contains(mobile) {
            // If mobile is duplicate throw error
            throw MobileError.alreadyExists
        } else {
            // If mobile is new add to set
            mobileStorage.insert(mobile)
            return mobile
        }
    } // .save() method end
    
    func delete(_ product: Mobile) throws {
        // Chek product to exist in storage
        if mobileStorage.contains(product) {
            // If product is new throw error
            throw MobileError.notFound
        } else {
            // If storage containts product, remove it
            mobileStorage.remove(product)
        }
    } // .delete() method end
    
    func exists(_ product: Mobile) -> Bool {
        if mobileStorage.contains(product){
            return true
        }
        return false
    } // .exist() method end
    
} // MobileController class end

//MARK: - Mobile controller test class
class MobileControllerTests: XCTestCase {
    var controller: MobileController!
    
    override func setUp() async throws {
        let mobile = Mobile(imei: "Baz", model: "Bar")
        controller = MobileController()
        controller.mobileStorage.insert(mobile)
    }
    
    override func tearDown() async throws {
        controller = nil
    }
    
    
    
}

// Start testing
TestRunner().runTests(testClass: MobileControllerTests.self)




