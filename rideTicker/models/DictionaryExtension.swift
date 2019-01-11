//
//  DictionaryExtension.swift
//
//  Created by Darktt on 16/9/7.
//  Copyright © 2016 Darktt. All rights reserved.
//

import Foundation

// MARK: - DictionaryKey -

public struct DictionaryKey<K, V>: RawRepresentable where K: Hashable
{
    public var rawValue: K
    
    public init(rawValue: K)
    {
        self.rawValue = rawValue
    }
}

// MARK: - Protocol -
// MARK: #DictionaryKeyConvertible

public protocol DictionaryKeyConvertible { }

extension DictionaryKeyConvertible
{
    public static func key<K: Hashable>(_ key: K) -> DictionaryKey<K, Self>
    {
        let key = DictionaryKey<K, Self>(rawValue: key)
        
        return key
    }
}

// MARK: - Extensions -

public extension Dictionary
{
    subscript<V>(key: DictionaryKey<Key, V>) -> V? {
        
        set {
            
            self[key.rawValue] = newValue as? Value
        }
        
        get {
            
            return self[key.rawValue] as? V
        }
    }
}

// MARK: - Confirm Protocols -
// MARK: #Array

extension Array: DictionaryKeyConvertible { }

// MARK: #Bool

extension Bool: DictionaryKeyConvertible { }

// MARK: #Character

extension Character: DictionaryKeyConvertible { }

// MARK: #CharacterSet

extension CharacterSet: DictionaryKeyConvertible { }

// MARK: #Data

extension Data: DictionaryKeyConvertible { }

// MARK: #Dictionary

extension Dictionary: DictionaryKeyConvertible { }

// MARK: #Double

extension Double: DictionaryKeyConvertible { }

// MARK: #Float

extension Float: DictionaryKeyConvertible { }

// MARK: #Int

extension Int: DictionaryKeyConvertible { }

// MARK: #Int8

extension Int8: DictionaryKeyConvertible { }

// MARK: #Int16

extension Int16: DictionaryKeyConvertible { }

// MARK: #Int32

extension Int32: DictionaryKeyConvertible { }

// MARK: #Int64

extension Int64: DictionaryKeyConvertible { }

// MARK: #Set

extension Set: DictionaryKeyConvertible { }

// MARK: #String

extension String: DictionaryKeyConvertible { }

// MARK: #UUID

extension UUID: DictionaryKeyConvertible { }

// MARK: #URL

extension URL: DictionaryKeyConvertible { }

#if canImport(AppKit)

import AppKit

// MARK: #NSColor

extension NSColor: DictionaryKeyConvertible { }

// MARK: #NSImage

extension NSImage: DictionaryKeyConvertible { }

#endif

#if canImport(CoreGraphics)

import CoreGraphics

// MARK: #CGFloat

extension CGFloat: DictionaryKeyConvertible { }

// MARK: #CGSize

extension CGSize: DictionaryKeyConvertible { }

// MARK: #CGPoint

extension CGPoint: DictionaryKeyConvertible { }

// MARK: #CGRect

extension CGRect: DictionaryKeyConvertible { }

#endif

#if canImport(CoreBluetooth)

import CoreBluetooth

// MARK: #CBUUID

extension CBUUID: DictionaryKeyConvertible { }

#endif

#if canImport(UIKit)

import UIKit

// MARK: #UIColor

extension UIColor: DictionaryKeyConvertible { }

// MARK: UIEdgeInsets

extension UIEdgeInsets: DictionaryKeyConvertible { }

// MARK: #UIImage

extension UIImage: DictionaryKeyConvertible { }

// MARK: #UIView.AnimationCurve

extension UIView.AnimationCurve: DictionaryKeyConvertible { }

#endif

#if canImport(Photos)

import Photos

// MARK: #PHAsset

@available(iOS 8.0, OSX 10.13, tvOS 10.0, *)
extension PHAsset: DictionaryKeyConvertible { }

#endif
