import XCTest

final class ContractToTests: XCTestCase {

    func test_math() {
        // Проверяем простую математику
        let a = 2
        let b = 3
        let result = a + b

        XCTAssertEqual(result, 5)
    }
}
