//
//  FilterToken.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 04/09/2025.
//
import SwiftUI

struct FilterToken: View {
    let token: SBSearchToken
    let fg: Color
    let bg: Color
    var body: some View {
        Text(token.value)
            .font(.callout)
            .fontWeight(.medium)
            .foregroundStyle(fg)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(bg)
            .clipShape(Capsule())
    }
}
