import XCTest

/**
 A proxy method to execute `XCTAssert` after given `timeout`. Other parameters are forwarded to `XCTAssert` call as is.
 - Parameter timeout: How long to wait until `expression` becomes `true`.
 */
public func asyncAssert(
    _ expression: @escaping @autoclosure () throws -> Bool,
    _ message: @escaping @autoclosure () -> String = "",
    timeout: TimeInterval = Defaults.asyncTimeout,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    asyncAssertScheduler(timeout: timeout) {
        XCTAssert(try expression(), message(), file: file, line: line)
    }
}

/**
 A proxy method to execute `XCTAssertEqual` after given `timeout`. Other parameters are forwarded to `XCTAssertEqual` call as is.
 - Parameter timeout: How long to wait until `expression` becomes `true`.
 */
public func asyncAssertEqual<T: Equatable>(
    _ expression1: @escaping @autoclosure () throws -> T?,
    _ expression2: @escaping @autoclosure () throws -> T?,
    _ message: @escaping @autoclosure () -> String = "",
    timeout: TimeInterval = Defaults.asyncTimeout,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    asyncAssertScheduler(timeout: timeout) {
        XCTAssertEqual(try expression1(), try expression2(), message(), file: file, line: line)
    }
}

/**
 A proxy method to execute `XCTAssertIdentical` after given `timeout`. Other parameters are forwarded to `XCTAssertIdentical` call as is.
 - Parameter timeout: How long to wait until `expression` becomes `true`.
 */
public func asyncAssertIdenticalTo(
    _ expression1: @escaping @autoclosure () throws -> AnyObject?,
    _ expression2: @escaping @autoclosure () throws -> AnyObject?,
    _ message: @escaping @autoclosure () -> String = "",
    timeout: TimeInterval = Defaults.asyncTimeout,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    asyncAssertScheduler(timeout: timeout) {
        XCTAssertIdentical(try expression1(), try expression2(), message(), file: file, line: line)
    }
}

/**
 A proxy method to execute `XCTAssertTrue` after given `timeout`. Other parameters are forwarded to `XCTAssertTrue` call as is.
 - Parameter timeout: How long to wait until `expression` becomes `true`.
 */
public func asyncAssertTrue(
    _ expression: @escaping @autoclosure () throws -> Bool,
    _ message: @escaping @autoclosure () -> String = "",
    timeout: TimeInterval = Defaults.asyncTimeout,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    asyncAssertScheduler(timeout: timeout) {
        XCTAssertTrue(try expression(), message(), file: file, line: line)
    }
}

/**
 A proxy method to execute `XCTAssertFalse` after given `timeout`. Other parameters are forwarded to `XCTAssertFalse` call as is.
 - Parameter timeout: How long to wait until `expression` becomes `true`.
 */
public func asyncAssertFalse(
    _ expression: @escaping @autoclosure () throws -> Bool,
    _ message: @escaping @autoclosure () -> String = "",
    timeout: TimeInterval = Defaults.asyncTimeout,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    asyncAssertScheduler(timeout: timeout) {
        XCTAssertFalse(try expression(), message(), file: file, line: line)
    }
}

/**
 A proxy method to execute `XCTAssertNil` after given `timeout`. Other parameters are forwarded to `XCTAssertNil` call as is.
 - Parameter timeout: How long to wait until `expression` becomes `true`.
 */
public func asyncAssertNil(
    _ expression: @escaping @autoclosure () throws -> Any?,
    _ message: @escaping @autoclosure () -> String = "",
    timeout: TimeInterval = Defaults.asyncTimeout,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    asyncAssertScheduler(timeout: timeout) {
        XCTAssertNil(try expression(), message(), file: file, line: line)
    }
}

/**
 A proxy method to execute `XCTAssertNotNil` after given `timeout`. Other parameters are forwarded to `XCTAssertNotNil` call as is.
 - Parameter timeout: How long to wait until `expression` becomes `true`.
 */
public func asyncAssertNotNil(
    _ expression: @escaping @autoclosure () throws -> Any?,
    _ message: @escaping @autoclosure () -> String = "",
    timeout: TimeInterval = Defaults.asyncTimeout,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    asyncAssertScheduler(timeout: timeout) {
        XCTAssertNotNil(try expression(), message(), file: file, line: line)
    }
}

/**
 A handy wrapper for an expectation
 */
public func waitUntil(
    timeout: TimeInterval = Defaults.asyncTimeout,
    action: @escaping (@escaping () -> Void) -> Void
) {
    let expectation = XCTestExpectation(description: "Wait for \(timeout) seconds")
    action(expectation.fulfill)
    _ = XCTWaiter.wait(for: [expectation], timeout: timeout + Defaults.waitForExpectationExtraDuration)
}

public func fail(
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTFail(file: file, line: line)
}

private func asyncAssertScheduler(
    timeout: TimeInterval,
    assertClosure: @escaping () throws -> ()
) {
    let expectation = XCTestExpectation(description: "Wait for \(timeout) seconds")
    DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
        try! assertClosure()
        expectation.fulfill()
    }
    _ = XCTWaiter.wait(for: [expectation], timeout: timeout + Defaults.waitForExpectationExtraDuration)
}
