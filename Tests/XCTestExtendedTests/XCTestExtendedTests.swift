import XCTest
@testable import XCTestExtended

final class AsyncAssertSpec: XCTestCase {

	private let eps: TimeInterval = 0.5
	private let timeout: TimeInterval = 3
	private let repeatFrequency: TimeInterval = 0.05

	func testAssertDispatchAfter() {
        var i = 1
		let startDate = Date()
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.change(&i, to: 2)
		}
		xeAsyncAssert(i == 2, timeout: timeout, repeatFrequency: nil)
		XCTAssertGreaterThan(Date().timeIntervalSince(startDate), timeout - eps)
		XCTAssertLessThan(Date().timeIntervalSince(startDate), timeout + eps)
    }

	func testAssertSyncChange() {
		var i = 1
		let startDate = Date()
		self.change(&i, to: 3)
		xeAsyncAssert(i == 3, timeout: timeout, repeatFrequency: nil)
		XCTAssertGreaterThan(Date().timeIntervalSince(startDate), timeout - eps)
		XCTAssertLessThan(Date().timeIntervalSince(startDate), timeout + eps)
	}

	func testAssertEqualDispatchAfter() {
		var i = 1
		let b = 4
		let startDate = Date()
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.change(&i, to: b)
		}
		xeAsyncAssertEqual(i, b, timeout: timeout)
		XCTAssertGreaterThan(Date().timeIntervalSince(startDate), timeout - eps)
		XCTAssertLessThan(Date().timeIntervalSince(startDate), timeout + eps)
	}

	func testAssertTrueDispatchAfter() {
		var i = 1
		let startDate = Date()
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.change(&i, to: 2)
		}
		xeAsyncAssertTrue(i == 2, timeout: timeout, repeatFrequency: nil)
		XCTAssertGreaterThan(Date().timeIntervalSince(startDate), timeout - eps)
		XCTAssertLessThan(Date().timeIntervalSince(startDate), timeout + eps)
	}

	private func change<T>(
		_ value: inout T,
		to: T
	) {
		value = to
	}
}
