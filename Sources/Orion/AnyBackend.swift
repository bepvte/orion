import Foundation

public struct AnyBackend: Backend {
    public struct Builder: HookBuilder {
        fileprivate var builder: HookBuilder
        fileprivate init(_ builder: HookBuilder) {
            self.builder = builder
        }

        public mutating func addFunctionHook(
            _ function: Function,
            replacement: UnsafeMutableRawPointer,
            completion: @escaping (UnsafeMutableRawPointer) -> Void
        ) {
            builder.addFunctionHook(function, replacement: replacement, completion: completion)
        }

        public mutating func addMethodHook(
            cls: AnyClass,
            sel: Selector,
            replacement: UnsafeMutableRawPointer,
            completion: @escaping (UnsafeMutableRawPointer) -> Void
        ) {
            builder.addMethodHook(cls: cls, sel: sel, replacement: replacement, completion: completion)
        }
    }

    private var _hook: ((inout Builder) -> Void) -> Void

    public init<UnderlyingBackend: Backend>(_ backend: UnderlyingBackend) {
        _hook = { build in
            backend.hook {
                var builder = Builder($0)
                build(&builder)
                guard let converted = builder.builder as? UnderlyingBackend.Builder else {
                    fatalError("Underlying type of erased hook builder changed")
                }
                $0 = converted
            }
        }
    }

    public func hook(_ build: (inout Builder) -> Void) {
        _hook(build)
    }
}