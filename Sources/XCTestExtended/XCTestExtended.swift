import XCTest

extension XCTestCase {

	/**
	 A proxy method to execute `XCTAssert` after given `timeout`. Parameters are forwarded to `XCTAssert` call as is.
	 - Parameter timeout: How long to wait until `expression` becomes `true`.
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

	/**
	 A proxy method to execute `XCTAssertEqual` after given `timeout`. Parameters are forwarded to `XCTAssert` call as is.
	 - Parameter timeout: How long to wait until `expression` becomes `true`.
	 */
	public func xeAsyncAssertEqual<T: Equatable>(
		_ expression1: @escaping @autoclosure () throws -> T,
		_ expression2: @escaping @autoclosure () throws -> T,
		_ message: @escaping @autoclosure () -> String = "",
		timeout: TimeInterval = Defaults.asyncTimeout,
		repeatFrequency: TimeInterval? = Defaults.asyncRepeatFrequency,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		asyncAssertScheduler(timeout: timeout, condition: try expression1() == expression2()) {
			XCTAssertEqual(try expression1(), try expression2(), message(), file: file, line: line)
		}
	}

	/**
	 A proxy method to execute `XCTAssertEqual` after given `timeout`. Parameters are forwarded to `XCTAssert` call as is.
	 - Parameter timeout: How long to wait until `expression` becomes `true`.
	 */
	public func xeAsyncAssertTrue(
		_ expression: @escaping @autoclosure () throws -> Bool,
		_ message: @escaping @autoclosure () -> String = "",
		timeout: TimeInterval = Defaults.asyncTimeout,
		repeatFrequency: TimeInterval? = Defaults.asyncRepeatFrequency,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		asyncAssertScheduler(timeout: timeout, condition: try expression()) {
			XCTAssertTrue(try expression(), message(), file: file, line: line)
		}
	}

	/**
	 A handy wrapper for an expectation
	 */
//	public func waitUntil(
//		timeout: TimeInterval = Defaults.asyncTimeout,
//		action: @escaping (@escaping () -> Void) -> Void
//	) {
//		let expectation = expectation(description: "Wait for \(timeout) seconds")
//		action(expectation.fulfill)
//		waitForExpectations(timeout: timeout)
//
//	}
//
//	public func fail(
//		file: StaticString = #filePath,
//		line: UInt = #line
//	) {
//		XCTFail(file: file, line: line)
//	}

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

}
