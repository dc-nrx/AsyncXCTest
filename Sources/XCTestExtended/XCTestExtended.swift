import XCTest

extension XCTestCase {

	public func xeAsyncAssert(
		_ expression: @escaping @autoclosure () throws -> Bool,
		_ message: @escaping @autoclosure () -> String = "",
		timeout: TimeInterval = 3,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let expectation = expectation(description: "Wait for \(timeout) seconds")
		DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
			try! XCTAssert(expression(), message(), file: file, line: line)
			expectation.fulfill()
		}
		waitForExpectations(timeout: timeout + 0.2)
	}

}
