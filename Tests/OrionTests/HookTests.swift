import XCTest
import Orion

// NOTE: We don't need the linux testing stuff here because the
// runtime can only be built on platforms with Objective-C

class MyFunctionHook: FunctionHook {
    static let target = Function(image: nil, name: "socket")

    func function(foo: Int32, bar: Int32) -> Int32 {
        _ = orig { function(foo: foo, bar: bar) }
        return 1
    }
}

class MyHook: NamedClassHook<NSObject> {
    static let targetName = "NSDateFormatter"

    func string(fromDate date: Date) -> String {
        let actual = orig { string(fromDate: date) }
        return "Swizzled: '\(actual)'"
    }

    @objc(localizedStringFromDate:dateStyle:timeStyle:)
    class func localizedString(
        from date: Date, dateStyle dstyle: DateFormatter.Style, timeStyle tstyle: DateFormatter.Style
    ) -> String {
        "Class method: \(orig { localizedString(from: date, dateStyle: dstyle, timeStyle: tstyle) })"
    }
}

final class HookTests: XCTestCase {
    func testClassHook() throws {
        // TODO: Maybe don't swizzle system stuff in tests? It might break the XCTest harness in
        // fact the times logged by Xcode are already broken because they're prefixed with HAX:

        let date = Date(timeIntervalSince1970: 0)

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateStyle = .short
        XCTAssertEqual(formatter.string(from: date), "Swizzled: '1/1/70'")

        let str = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        XCTAssertEqual(str, "Class method: Jan 1, 1970")
    }
}