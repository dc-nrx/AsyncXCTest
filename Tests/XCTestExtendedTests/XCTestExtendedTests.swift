import XCTest
@testable import XCTestExtended

final class AsyncAssertSpec: XCTestCase {

	func testExample() throws {
        var i = 1
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.change(&i, to: 2)
		}
		xeAsyncAssert(i == 2)
    }

	private func change<T>(
		_ value: inout T,
		to: T
	) {
		value = to
	}
}
