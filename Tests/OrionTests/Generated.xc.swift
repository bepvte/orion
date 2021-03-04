// swiftlint:disable all

import Foundation
import Orion
import OrionBackend_Fishhook
import OrionTestSupport

extension BasicHook {
    enum _Glue: _GlueClassHook {
        typealias HookType = BasicHook

        final class OrigType: BasicHook, _GlueClassHookTrampoline {
            @objc override func someTestMethod() -> String {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }

            @objc override func someTestMethod(withArgument arg1: Int32) -> String {
                _Glue.orion_orig2(target, _Glue.orion_sel2, arg1)
            }

            @objc class override func someTestMethod2(withArgument arg1: Int32) -> String {
                _Glue.orion_orig3(target, _Glue.orion_sel3, arg1)
            }
        }

        final class SuprType: BasicHook, _GlueClassHookTrampoline {
            @objc override func someTestMethod() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel1) }
            }

            @objc override func someTestMethod(withArgument arg1: Int32) -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector, Int32) -> String).self) { $0($1, _Glue.orion_sel2, arg1) }
            }

            @objc class override func someTestMethod2(withArgument arg1: Int32) -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector, Int32) -> String).self) { $0($1, _Glue.orion_sel3, arg1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(BasicHook.someTestMethod as (BasicHook) -> () -> String)
        private static var orion_orig1: @convention(c) (Target, Selector) -> String = { target, _cmd in
            BasicHook(target: target).someTestMethod()
        }

        private static let orion_sel2 = #selector(BasicHook.someTestMethod(withArgument:) as (BasicHook) -> (Int32) -> String)
        private static var orion_orig2: @convention(c) (Target, Selector, Int32) -> String = { target, _cmd, arg1 in
            BasicHook(target: target).someTestMethod(withArgument:)(arg1)
        }

        private static let orion_sel3 = #selector(BasicHook.someTestMethod2(withArgument:) as (Int32) -> String)
        private static var orion_orig3: @convention(c) (AnyClass, Selector, Int32) -> String = { target, _cmd, arg1 in
            BasicHook.someTestMethod2(withArgument:)(arg1)
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
            builder.addHook(orion_sel2, orion_orig2, isClassMethod: false) { orion_orig2 = $0 }
            builder.addHook(orion_sel3, orion_orig3, isClassMethod: true) { orion_orig3 = $0 }
        }
    }
}

extension ActivationHook {
    enum _Glue: _GlueClassHook {
        typealias HookType = ActivationHook

        final class OrigType: ActivationHook, _GlueClassHookTrampoline {
            @objc override func someDidActivateMethod() -> String {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }
        }

        final class SuprType: ActivationHook, _GlueClassHookTrampoline {
            @objc override func someDidActivateMethod() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(ActivationHook.someDidActivateMethod as (ActivationHook) -> () -> String)
        private static var orion_orig1: @convention(c) (Target, Selector) -> String = { target, _cmd in
            ActivationHook(target: target).someDidActivateMethod()
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
        }
    }
}

extension NotHook {
    enum _Glue: _GlueClassHook {
        typealias HookType = NotHook

        final class OrigType: NotHook, _GlueClassHookTrampoline {
            @objc override func someUnhookedMethod() -> String {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }
        }

        final class SuprType: NotHook, _GlueClassHookTrampoline {
            @objc override func someUnhookedMethod() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(NotHook.someUnhookedMethod as (NotHook) -> () -> String)
        private static var orion_orig1: @convention(c) (Target, Selector) -> String = { target, _cmd in
            NotHook(target: target).someUnhookedMethod()
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
        }
    }
}

extension NamedBasicHook {
    enum _Glue: _GlueClassHook {
        typealias HookType = NamedBasicHook

        final class OrigType: NamedBasicHook, _GlueClassHookTrampoline {
            @objc override func methodForNamedTest() -> Bool {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }

            @objc class override func classMethodForNamedTest(withArgument arg1: String) -> [String] {
                _Glue.orion_orig2(target, _Glue.orion_sel2, arg1)
            }
        }

        final class SuprType: NamedBasicHook, _GlueClassHookTrampoline {
            @objc override func methodForNamedTest() -> Bool {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> Bool).self) { $0($1, _Glue.orion_sel1) }
            }

            @objc class override func classMethodForNamedTest(withArgument arg1: String) -> [String] {
                callSuper((@convention(c) (UnsafeRawPointer, Selector, String) -> [String]).self) { $0($1, _Glue.orion_sel2, arg1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(NamedBasicHook.methodForNamedTest as (NamedBasicHook) -> () -> Bool)
        private static var orion_orig1: @convention(c) (Target, Selector) -> Bool = { target, _cmd in
            NamedBasicHook(target: target).methodForNamedTest()
        }

        private static let orion_sel2 = #selector(NamedBasicHook.classMethodForNamedTest(withArgument:) as (String) -> [String])
        private static var orion_orig2: @convention(c) (AnyClass, Selector, String) -> [String] = { target, _cmd, arg1 in
            NamedBasicHook.classMethodForNamedTest(withArgument:)(arg1)
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
            builder.addHook(orion_sel2, orion_orig2, isClassMethod: true) { orion_orig2 = $0 }
        }
    }
}

extension BasicSubclass {
    enum _Glue: _GlueClassHook {
        typealias HookType = BasicSubclass

        final class OrigType: BasicSubclass, _GlueClassHookTrampoline {
            @objc override func someTestMethod() -> String {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }

            @objc override func subclassableTestMethod() -> String {
                _Glue.orion_orig3(target, _Glue.orion_sel3)
            }

            @objc class override func subclassableTestMethod1() -> String {
                _Glue.orion_orig4(target, _Glue.orion_sel4)
            }
        }

        final class SuprType: BasicSubclass, _GlueClassHookTrampoline {
            @objc override func someTestMethod() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel1) }
            }

            @objc override func subclassableTestMethod() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel3) }
            }

            @objc class override func subclassableTestMethod1() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel4) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(BasicSubclass.someTestMethod as (BasicSubclass) -> () -> String)
        private static var orion_orig1: @convention(c) (Target, Selector) -> String = { target, _cmd in
            BasicSubclass(target: target).someTestMethod()
        }

        private static let orion_sel2 = #selector(BasicSubclass.someNewMethod as (BasicSubclass) -> () -> String)
        private static var orion_imp2: @convention(c) (Target, Selector) -> String = { target, _cmd in
            BasicSubclass(target: target).someNewMethod()
        }

        private static let orion_sel3 = #selector(BasicSubclass.subclassableTestMethod as (BasicSubclass) -> () -> String)
        private static var orion_orig3: @convention(c) (Target, Selector) -> String = { target, _cmd in
            BasicSubclass(target: target).subclassableTestMethod()
        }

        private static let orion_sel4 = #selector(BasicSubclass.subclassableTestMethod1 as () -> String)
        private static var orion_orig4: @convention(c) (AnyClass, Selector) -> String = { target, _cmd in
            BasicSubclass.subclassableTestMethod1()
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
            addMethod(orion_sel2, orion_imp2, isClassMethod: false)
            builder.addHook(orion_sel3, orion_orig3, isClassMethod: false) { orion_orig3 = $0 }
            builder.addHook(orion_sel4, orion_orig4, isClassMethod: true) { orion_orig4 = $0 }
        }
    }
}

extension NamedBasicSubclass {
    enum _Glue: _GlueClassHook {
        typealias HookType = NamedBasicSubclass

        final class OrigType: NamedBasicSubclass, _GlueClassHookTrampoline {
            @objc override func subclassableNamedTestMethod() -> String {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }

            @objc class override func subclassableNamedTestMethod1() -> String {
                _Glue.orion_orig2(target, _Glue.orion_sel2)
            }
        }

        final class SuprType: NamedBasicSubclass, _GlueClassHookTrampoline {
            @objc override func subclassableNamedTestMethod() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel1) }
            }

            @objc class override func subclassableNamedTestMethod1() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel2) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(NamedBasicSubclass.subclassableNamedTestMethod as (NamedBasicSubclass) -> () -> String)
        private static var orion_orig1: @convention(c) (Target, Selector) -> String = { target, _cmd in
            NamedBasicSubclass(target: target).subclassableNamedTestMethod()
        }

        private static let orion_sel2 = #selector(NamedBasicSubclass.subclassableNamedTestMethod1 as () -> String)
        private static var orion_orig2: @convention(c) (AnyClass, Selector) -> String = { target, _cmd in
            NamedBasicSubclass.subclassableNamedTestMethod1()
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
            builder.addHook(orion_sel2, orion_orig2, isClassMethod: true) { orion_orig2 = $0 }
        }
    }
}

extension AdditionHook {
    enum _Glue: _GlueClassHook {
        typealias HookType = AdditionHook

        final class OrigType: AdditionHook, _GlueClassHookTrampoline {}

        final class SuprType: AdditionHook, _GlueClassHookTrampoline {}

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(AdditionHook.someTestProtocolMethod as (AdditionHook) -> () -> String)
        private static var orion_imp1: @convention(c) (Target, Selector) -> String = { target, _cmd in
            AdditionHook(target: target).someTestProtocolMethod()
        }

        private static let orion_sel2 = #selector(AdditionHook.someTestProtocolClassMethod as () -> String)
        private static var orion_imp2: @convention(c) (AnyClass, Selector) -> String = { target, _cmd in
            AdditionHook.someTestProtocolClassMethod()
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            addMethod(orion_sel1, orion_imp1, isClassMethod: false)
            addMethod(orion_sel2, orion_imp2, isClassMethod: true)
        }
    }
}

extension InheritedHook {
    enum _Glue: _GlueClassHook {
        typealias HookType = InheritedHook

        final class OrigType: InheritedHook, _GlueClassHookTrampoline {
            @objc class override func someTestMethod3() -> String {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }
        }

        final class SuprType: InheritedHook, _GlueClassHookTrampoline {
            @objc class override func someTestMethod3() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(InheritedHook.someTestMethod3 as () -> String)
        private static var orion_orig1: @convention(c) (AnyClass, Selector) -> String = { target, _cmd in
            InheritedHook.someTestMethod3()
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: true) { orion_orig1 = $0 }
        }
    }
}

extension InitHook {
    enum _Glue: _GlueClassHook {
        typealias HookType = InitHook

        final class OrigType: InitHook, _GlueClassHookTrampoline {
            @objc override func `init`() -> Target {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }

            @objc override func `init`(withX arg1: Int32) -> Target {
                _Glue.orion_orig2(target, _Glue.orion_sel2, arg1)
            }
        }

        final class SuprType: InitHook, _GlueClassHookTrampoline {
            @objc override func `init`() -> Target {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> Target).self) { $0($1, _Glue.orion_sel1) }
            }

            @objc override func `init`(withX arg1: Int32) -> Target {
                callSuper((@convention(c) (UnsafeRawPointer, Selector, Int32) -> Target).self) { $0($1, _Glue.orion_sel2, arg1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(InitHook.`init` as (InitHook) -> () -> Target)
        private static var orion_orig1: @convention(c) (Target, Selector) -> Target = { target, _cmd in
            InitHook(target: target).`init`()
        }

        private static let orion_sel2 = #selector(InitHook.`init`(withX:) as (InitHook) -> (Int32) -> Target)
        private static var orion_orig2: @convention(c) (Target, Selector, Int32) -> Target = { target, _cmd, arg1 in
            InitHook(target: target).`init`(withX:)(arg1)
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
            builder.addHook(orion_sel2, orion_orig2, isClassMethod: false) { orion_orig2 = $0 }
        }
    }
}

extension SuperHook {
    enum _Glue: _GlueClassHook {
        typealias HookType = SuperHook

        final class OrigType: SuperHook, _GlueClassHookTrampoline {
            @objc override func description() -> String {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }

            @objc override func hooked() -> String {
                _Glue.orion_orig2(target, _Glue.orion_sel2)
            }
        }

        final class SuprType: SuperHook, _GlueClassHookTrampoline {
            @objc override func description() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel1) }
            }

            @objc override func hooked() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel2) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(SuperHook.description as (SuperHook) -> () -> String)
        private static var orion_orig1: @convention(c) (Target, Selector) -> String = { target, _cmd in
            SuperHook(target: target).description()
        }

        private static let orion_sel2 = #selector(SuperHook.hooked as (SuperHook) -> () -> String)
        private static var orion_orig2: @convention(c) (Target, Selector) -> String = { target, _cmd in
            SuperHook(target: target).hooked()
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
            builder.addHook(orion_sel2, orion_orig2, isClassMethod: false) { orion_orig2 = $0 }
        }
    }
}

extension PropertyHookX {
    enum _Glue: _GlueClassHook {
        typealias HookType = PropertyHookX

        final class OrigType: PropertyHookX, _GlueClassHookTrampoline {
            @objc override func getXValue() -> Int {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }

            @objc override func setXValue(_ arg1: Int)  {
                _Glue.orion_orig2(target, _Glue.orion_sel2, arg1)
            }
        }

        final class SuprType: PropertyHookX, _GlueClassHookTrampoline {
            @objc override func getXValue() -> Int {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> Int).self) { $0($1, _Glue.orion_sel1) }
            }

            @objc override func setXValue(_ arg1: Int)  {
                callSuper((@convention(c) (UnsafeRawPointer, Selector, Int) -> Void).self) { $0($1, _Glue.orion_sel2, arg1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(PropertyHookX.getXValue as (PropertyHookX) -> () -> Int)
        private static var orion_orig1: @convention(c) (Target, Selector) -> Int = { target, _cmd in
            PropertyHookX(target: target).getXValue()
        }

        private static let orion_sel2 = #selector(PropertyHookX.setXValue(_:) as (PropertyHookX) -> (Int) -> Void)
        private static var orion_orig2: @convention(c) (Target, Selector, Int) -> Void = { target, _cmd, arg1 in
            PropertyHookX(target: target).setXValue(_:)(arg1)
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
            builder.addHook(orion_sel2, orion_orig2, isClassMethod: false) { orion_orig2 = $0 }
        }
    }
}

extension PropertyHookY {
    enum _Glue: _GlueClassHook {
        typealias HookType = PropertyHookY

        final class OrigType: PropertyHookY, _GlueClassHookTrampoline {
            @objc override func getYValue() -> Int {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }

            @objc override func setYValue(_ arg1: Int)  {
                _Glue.orion_orig2(target, _Glue.orion_sel2, arg1)
            }
        }

        final class SuprType: PropertyHookY, _GlueClassHookTrampoline {
            @objc override func getYValue() -> Int {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> Int).self) { $0($1, _Glue.orion_sel1) }
            }

            @objc override func setYValue(_ arg1: Int)  {
                callSuper((@convention(c) (UnsafeRawPointer, Selector, Int) -> Void).self) { $0($1, _Glue.orion_sel2, arg1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(PropertyHookY.getYValue as (PropertyHookY) -> () -> Int)
        private static var orion_orig1: @convention(c) (Target, Selector) -> Int = { target, _cmd in
            PropertyHookY(target: target).getYValue()
        }

        private static let orion_sel2 = #selector(PropertyHookY.setYValue(_:) as (PropertyHookY) -> (Int) -> Void)
        private static var orion_orig2: @convention(c) (Target, Selector, Int) -> Void = { target, _cmd, arg1 in
            PropertyHookY(target: target).setYValue(_:)(arg1)
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
            builder.addHook(orion_sel2, orion_orig2, isClassMethod: false) { orion_orig2 = $0 }
        }
    }
}

extension PropertyHook2 {
    enum _Glue: _GlueClassHook {
        typealias HookType = PropertyHook2

        final class OrigType: PropertyHook2, _GlueClassHookTrampoline {
            @objc override func getXValue() -> Int {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }

            @objc override func setXValue(_ arg1: Int)  {
                _Glue.orion_orig2(target, _Glue.orion_sel2, arg1)
            }
        }

        final class SuprType: PropertyHook2, _GlueClassHookTrampoline {
            @objc override func getXValue() -> Int {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> Int).self) { $0($1, _Glue.orion_sel1) }
            }

            @objc override func setXValue(_ arg1: Int)  {
                callSuper((@convention(c) (UnsafeRawPointer, Selector, Int) -> Void).self) { $0($1, _Glue.orion_sel2, arg1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(PropertyHook2.getXValue as (PropertyHook2) -> () -> Int)
        private static var orion_orig1: @convention(c) (Target, Selector) -> Int = { target, _cmd in
            PropertyHook2(target: target).getXValue()
        }

        private static let orion_sel2 = #selector(PropertyHook2.setXValue(_:) as (PropertyHook2) -> (Int) -> Void)
        private static var orion_orig2: @convention(c) (Target, Selector, Int) -> Void = { target, _cmd, arg1 in
            PropertyHook2(target: target).setXValue(_:)(arg1)
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
            builder.addHook(orion_sel2, orion_orig2, isClassMethod: false) { orion_orig2 = $0 }
        }
    }
}

extension DeHook {
    enum _Glue: _GlueClassHook {
        typealias HookType = DeHook

        final class OrigType: DeHook, _GlueClassHookTrampoline {
            override func deinitializer() -> DeinitPolicy {
                deinitOrigError()
            }
        }

        final class SuprType: DeHook, _GlueClassHookTrampoline {
            override func deinitializer() -> DeinitPolicy {
                deinitSuprError()
            }
        }

        static let storage = initializeStorage()

        private static var orion_orig1: @convention(c) (Any, Selector) -> Void = { _, _ in }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addDeinitializer(to: DeHook.self, getOrig: { orion_orig1 }, setOrig: { orion_orig1 = $0 })
        }
    }
}

extension DeSubHook1 {
    enum _Glue: _GlueClassHook {
        typealias HookType = DeSubHook1

        final class OrigType: DeSubHook1, _GlueClassHookTrampoline {}

        final class SuprType: DeSubHook1, _GlueClassHookTrampoline {}

        static let storage = initializeStorage()

        private static var orion_imp1: @convention(c) (Any, Selector) -> Void = { _, _ in }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addDeinitializer(to: DeSubHook1.self, getOrig: { orion_imp1 }, setOrig: { orion_imp1 = $0 })
        }
    }
}

extension DeSubHook2 {
    enum _Glue: _GlueClassHook {
        typealias HookType = DeSubHook2

        final class OrigType: DeSubHook2, _GlueClassHookTrampoline {
            override func deinitializer() -> DeinitPolicy {
                deinitOrigError()
            }
        }

        final class SuprType: DeSubHook2, _GlueClassHookTrampoline {
            override func deinitializer() -> DeinitPolicy {
                deinitSuprError()
            }
        }

        static let storage = initializeStorage()

        private static var orion_orig1: @convention(c) (Any, Selector) -> Void = { _, _ in }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addDeinitializer(to: DeSubHook2.self, getOrig: { orion_orig1 }, setOrig: { orion_orig1 = $0 })
        }
    }
}

extension GrHook {
    enum _Glue: _GlueClassHook {
        typealias HookType = GrHook

        final class OrigType: GrHook, _GlueClassHookTrampoline {
            @objc override func myString() -> String {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }
        }

        final class SuprType: GrHook, _GlueClassHookTrampoline {
            @objc override func myString() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(GrHook.myString as (GrHook) -> () -> String)
        private static var orion_orig1: @convention(c) (Target, Selector) -> String = { target, _cmd in
            GrHook(target: target).myString()
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
        }
    }
}

extension GrHook2 {
    enum _Glue: _GlueClassHook {
        typealias HookType = GrHook2

        final class OrigType: GrHook2, _GlueClassHookTrampoline {
            @objc override func mySecondString() -> String {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }
        }

        final class SuprType: GrHook2, _GlueClassHookTrampoline {
            @objc override func mySecondString() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(GrHook2.mySecondString as (GrHook2) -> () -> String)
        private static var orion_orig1: @convention(c) (Target, Selector) -> String = { target, _cmd in
            GrHook2(target: target).mySecondString()
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
        }
    }
}

extension GrHook3 {
    enum _Glue: _GlueClassHook {
        typealias HookType = GrHook3

        final class OrigType: GrHook3, _GlueClassHookTrampoline {
            @objc override func myThirdString() -> String {
                _Glue.orion_orig1(target, _Glue.orion_sel1)
            }
        }

        final class SuprType: GrHook3, _GlueClassHookTrampoline {
            @objc override func myThirdString() -> String {
                callSuper((@convention(c) (UnsafeRawPointer, Selector) -> String).self) { $0($1, _Glue.orion_sel1) }
            }
        }

        static let storage = initializeStorage()

        private static let orion_sel1 = #selector(GrHook3.myThirdString as (GrHook3) -> () -> String)
        private static var orion_orig1: @convention(c) (Target, Selector) -> String = { target, _cmd in
            GrHook3(target: target).myThirdString()
        }
    
        static func activate(withClassHookBuilder builder: inout _GlueClassHookBuilder) {
            builder.addHook(orion_sel1, orion_orig1, isClassMethod: false) { orion_orig1 = $0 }
        }
    }
}

extension AtoiHook {
    enum _Glue: _GlueFunctionHook {
        typealias HookType = AtoiHook

        final class OrigType: AtoiHook, _GlueFunctionHookTrampoline {
            override func function(_ arg1: UnsafePointer<Int8>) -> Int32 {
                _Glue.origFunction(arg1)
            }
        }

        static var origFunction: @convention(c) (UnsafePointer<Int8>) -> Int32 = { arg1 in
            AtoiHook().function(_:)(arg1)
        }

        static let storage = initializeStorage()
    }
}

extension AtofHook {
    enum _Glue: _GlueFunctionHook {
        typealias HookType = AtofHook

        final class OrigType: AtofHook, _GlueFunctionHookTrampoline {
            override func function(_ arg1: UnsafePointer<Int8>) -> Double {
                _Glue.origFunction(arg1)
            }
        }

        static var origFunction: @convention(c) (UnsafePointer<Int8>) -> Double = { arg1 in
            AtofHook().function(_:)(arg1)
        }

        static let storage = initializeStorage()
    }
}

extension StringCompareHook {
    enum _Glue: _GlueFunctionHook {
        typealias HookType = StringCompareHook

        final class OrigType: StringCompareHook, _GlueFunctionHookTrampoline {
            override func function(_ arg1: UnsafePointer<Int8>?, _ arg2: UnsafePointer<Int8>?) -> Int32 {
                _Glue.origFunction(arg1, arg2)
            }
        }

        static var origFunction: @convention(c) (UnsafePointer<Int8>?, UnsafePointer<Int8>?) -> Int32 = { arg1, arg2 in
            StringCompareHook().function(_:_:)(arg1, arg2)
        }

        static let storage = initializeStorage()
    }
}

@_cdecl("orion_init")
func orion_init() {
    HooksTweak.activate(
        hooks: [
            BasicHook._Glue.self,
            ActivationHook._Glue.self,
            NotHook._Glue.self,
            NamedBasicHook._Glue.self,
            BasicSubclass._Glue.self,
            NamedBasicSubclass._Glue.self,
            AdditionHook._Glue.self,
            InheritedHook._Glue.self,
            InitHook._Glue.self,
            SuperHook._Glue.self,
            PropertyHookX._Glue.self,
            PropertyHookY._Glue.self,
            PropertyHook2._Glue.self,
            DeHook._Glue.self,
            DeSubHook1._Glue.self,
            DeSubHook2._Glue.self,
            GrHook._Glue.self,
            GrHook2._Glue.self,
            GrHook3._Glue.self,
            AtoiHook._Glue.self,
            AtofHook._Glue.self,
            StringCompareHook._Glue.self
        ]
    )
}
