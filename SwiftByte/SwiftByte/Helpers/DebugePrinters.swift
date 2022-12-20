//
//  DebugePrinters.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation

/// Global function to help print  debug only
///
/// - Parameter e: error
func sbPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print(items, separator, terminator)
    #endif
}

/// Global function to help print `failure` on debug scheme only
///
/// - Parameter e: error
func printf(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print("❌", items, separator, terminator)
    #endif
}

/// Global function to help print `success` on debug scheme only
///
/// - Parameter e: error
func prints(_self: AnyClass? = nil, _ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let prefix = _self?.description() ?? ""
    print("✅" ,prefix, items, separator, terminator)
    #endif
}

/// Global function to help print `verbose` on debug scheme only
///
/// - Parameter e: error
func printv(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print("👀", items, separator, terminator)
    #endif
}
