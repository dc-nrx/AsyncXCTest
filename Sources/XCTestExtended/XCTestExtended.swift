import XCTest

public struct Defaults {

	public static let asyncTimeout: TimeInterval = 3

}

extension XCTestCase {

	public func xeAsyncAssert(
		_ expression: @escaping @autoclosure () throws -> Bool,
		_ message: @escaping @autoclosure () -> String = "",
		timeout: TimeInterval = Defaults.asyncTimeout,
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

	public func waitUntil(
		timeout: TimeInterval = Defaults.asyncTimeout,
		file: StaticString = #file,
		line: UInt = #line,
		action: @escaping (@escaping () -> Void) -> Void
	) {
		let expectation = expectation(description: "Wait for \(timeout) seconds")
		action(expectation.fulfill)
		waitForExpectations(timeout: timeout)
	}
}
