import XCTest

public struct Defaults {

	public static let asyncTimeout: TimeInterval = 3
	public static let asyncRepeatFrequency = 0.1
	public static let waitForExpectationExtraDuration = 0.1

}

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
		let expectation = expectation(description: "Wait for \(timeout) seconds")
		// Repeated evaluations
		if let repeatFrequency = repeatFrequency,
		   repeatFrequency < timeout {
			let _ = Timer(fire: Date() + repeatFrequency, interval: repeatFrequency, repeats: true) { _ in
				if (try? expression()) == true {
					expectation.fulfill()
				}
			}
		}
		// Evaluation after timeout
		DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
			try! XCTAssert(expression(), message(), file: file, line: line)
			expectation.fulfill()
		}
		waitForExpectations(timeout: timeout + Defaults.waitForExpectationExtraDuration)
	}

	/**
	 A handy wrapper for an expectation
	 */
	public func waitUntil(
		timeout: TimeInterval = Defaults.asyncTimeout,
//		file: StaticString = #file,
//		line: UInt = #line,
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
