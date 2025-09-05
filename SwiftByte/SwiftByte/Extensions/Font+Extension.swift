//
//  Font+Extension.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

extension Font {

    static func sysRound(_ style: TextStyle = .body, weight: Weight? = nil) -> Font {
        .system(style, design: .rounded, weight: weight)
    }

    static func sysRound(_ size: CGFloat, _ weight: Weight? = nil) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}
