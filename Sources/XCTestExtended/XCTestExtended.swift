import XCTest

extension XCTestCase {

	public func xeAsyncAssert(
		_ expression: @escaping @autoclosure () throws -> Bool,
		_ message: @escaping @autoclosure () -> String = "",
		timeout: TimeInterval = 3,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		asyncTest(interval: timeout) {
			XCTAssert(try expression(), message(), file: file, line: line)
		}
	}

	private func asyncTest(
		interval: TimeInterval = 3,
		test: @escaping () throws -> ()
	) {
		let expectation = expectation(description: "Wait for \(interval) seconds")
		DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
			try! test()
			expectation.fulfill()
		}
		waitForExpectations(timeout: interval + 0.2)
	}
}
