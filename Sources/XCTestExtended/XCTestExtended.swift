import XCTest

extension XCTestCase {

	/**
	 A proxy method to execute `XCTAssert` after given `timeout`. Parameters are forwarded to `XCTAssert` call as is.
	 - Parameter timeout: How long to wait until `expression` becomes `true`.
	 - Parameter repeatFrequency: Frequency of `expression` (re)evaluation. Used to reduce waiting duration.
	 If `nil`, `expression` will be evaluated just once after `timeout` have passed.
	 */
	public func xeAsyncAssert(
		_ expression: @escaping @autoclosure () throws -> Bool,
		_ message: @escaping @autoclosure () -> String = "",
		timeout: TimeInterval = Defaults.asyncTimeout,
		repeatFrequency: TimeInterval? = Defaults.asyncRepeatFrequency,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		asyncAssertScheduler(timeout: timeout, condition: try expression()) {
			XCTAssert(try expression(), message(), file: file, line: line)
		}
	}

	private func asyncAssertScheduler(
		timeout: TimeInterval,
		condition: @escaping @autoclosure () throws -> Bool,
		assertClosure: @escaping () throws -> ()
	) {
		let expectation = expectation(description: "Wait for \(timeout) seconds")
		DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
			try! assertClosure()
			expectation.fulfill()
		}
		waitForExpectations(timeout: timeout + Defaults.waitForExpectationExtraDuration)
	}

	/**
	 A handy wrapper for an expectation
	 */
	public func waitUntil(
		timeout: TimeInterval = Defaults.asyncTimeout,
		action: @escaping (@escaping () -> Void) -> Void
	) {
		let expectation = expectation(description: "Wait for \(timeout) seconds")
		action(expectation.fulfill)
		waitForExpectations(timeout: timeout)

	}

	public func fail(
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		XCTFail(file: file, line: line)
	}
}
