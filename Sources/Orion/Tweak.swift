import Foundation
import OrionC

public protocol Tweak {
    init()
}

extension Tweak {
    public func activate(backend: Backend, hooks: [ConcreteHook.Type]) {
        // this is effectively a no-op but we need it in order to prevent the
        // compiler from stripping out the constructor because it doesn't see
        // it being used
        __orion_constructor_c()

        hooks.lazy
            .filter { $0.shouldActivate }
            .forEach { $0.activate(withBackend: backend) }
    }
}

// a tweak which forces a custom backend
public protocol TweakWithBackend: Tweak {
    var backend: Backend { get }
}

extension TweakWithBackend {
    public func activate(hooks: [ConcreteHook.Type]) {
        activate(backend: backend, hooks: hooks)
    }
}

public struct DefaultTweak: Tweak {
    public init() {}
}