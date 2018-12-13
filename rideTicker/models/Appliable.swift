//
//  Appliable.swift
//
//  Created by Darktt on 18/6/12.
//  Copyright © 2018 Darktt. All rights reserved.
//

import Foundation

// MARK: - Appliable -

public protocol Appliable { }

extension Appliable
{
    @discardableResult
    public func apply(_ block: (Self) throws -> Void) rethrows -> Self
    {
        try block(self)
        
        return self
    }
    
    public static func apply(_ block: () throws -> Self) rethrows -> Self
    {
        return try block()
    }
}

extension NSObject : Appliable { }

// MARK: - Optional Appliable -

public extension Optional
{
    /// Unwrap object, when unwrap success will execute block and return object, otherwise return nil.
    ///
    /// - Parameter block: The block will be execute.
    /// - Returns: Unwraped object.
    /// - Throws: Error type throwed from block.
    @discardableResult
    public func unwrapped(_ block: (Wrapped) throws -> Void) rethrows -> Optional<Wrapped>
    {
        if case let .some(wrapped) = self {
            
            try block(wrapped)
        }
        
        return self
    }
    
    /// Unwrap and case down object, when case success will execute block and return object, otherwise return nil.
    ///
    /// - Parameters:
    ///   - type: Type to case.
    ///   - block: The block will be execute.
    /// - Returns: Unwraped and case down object.
    /// - Throws: Error type throwed from block.
    @discardableResult
    public func unwrapped<T>(as type: T.Type, _ block: (T) throws -> Void) rethrows -> Optional<T>?
    {
        guard case let .some(wrapped) = self, let caseType = wrapped as? T else {
            
            return nil
        }
        
        try block(caseType)
        
        return caseType
    }
}
