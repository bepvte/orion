import Orion
import Foundation
import Orion
import Foundation

private final class Orion_ClassHook1: MyHook, ConcreteClassHook {
    static let callState = CallState<ClassRequest>()
    let callState = CallState<ClassRequest>()

    private typealias Orion_Function1 = @convention(c) (Target, Selector, Date) -> String
    private static var orion_orig1: Orion_Function1 = { target, _cmd, arg1 in
        Orion_ClassHook1(target: target).string(fromDate:)(arg1)
    }
    private static let orion_sel1 = #selector(string(fromDate:) as (Self) -> (Date) -> String)
    @objc override func string(fromDate arg1: Date) -> String {
        switch callState.fetchRequest() {
        case nil:
            return super.string(fromDate:)(arg1)
        case .origCall:
            return Self.orion_orig1(target, Self.orion_sel1, arg1)
        case .superCall:
            return callSuper(Orion_Function1.self) { $0($1, Self.orion_sel1, arg1) }
        }
    }

    private typealias Orion_Function2 = @convention(c) (AnyClass, Selector, Date, DateFormatter.Style, DateFormatter.Style) -> String
    private static var orion_orig2: Orion_Function2 = { target, _cmd, arg1, arg2, arg3 in
        Orion_ClassHook1.localizedString(from:dateStyle:timeStyle:)(arg1, arg2, arg3)
    }
    private static let orion_sel2 = #selector(localizedString(from:dateStyle:timeStyle:) as (Date, DateFormatter.Style, DateFormatter.Style) -> String)
    @objc(localizedStringFromDate:dateStyle:timeStyle:)
        class override func localizedString(
            from arg1: Date, dateStyle arg2: DateFormatter.Style, timeStyle arg3: DateFormatter.Style
        ) -> String {
        switch callState.fetchRequest() {
        case nil:
            return super.localizedString(from:dateStyle:timeStyle:)(arg1, arg2, arg3)
        case .origCall:
            return Self.orion_orig2(target, Self.orion_sel2, arg1, arg2, arg3)
        case .superCall:
            return callSuper(Orion_Function2.self) { $0($1, Self.orion_sel2, arg1, arg2, arg3) }
        }
    }

    static func activate(withBackend backend: Backend) {
        register(backend, orion_sel1, &orion_orig1, isClassMethod: false)
        register(backend, orion_sel2, &orion_orig2, isClassMethod: true)
    }
}

private final class Orion_FunctionHook1: MyFunctionHook, ConcreteFunctionHook {
    let callState = CallState<FunctionRequest>()

    static var origFunction: @convention(c) (Int32, Int32) -> Int32 = { arg1, arg2 in
        Orion_FunctionHook1().function(foo:bar:)(arg1, arg2)
    }

    override func function(foo arg1: Int32, bar arg2: Int32) -> Int32 {
        switch callState.fetchRequest() {
        case nil:
            return super.function(foo:bar:)(arg1, arg2)
        case .origCall:
            return Self.origFunction(arg1, arg2)
        }
    }
}

@_cdecl("__orion_constructor")
func __orion_constructor() {
    DefaultTweak().activate(
        backend: InternalBackend(),
        hooks: [
            Orion_ClassHook1.self,
            Orion_FunctionHook1.self
        ]
    )
}