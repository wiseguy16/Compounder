//
//  NavBarModifier.swift
//  MFAScraps
//
//

import SwiftUI

// MARK: - WhiteNavBarModifier
public struct WhiteNavBarModifier: ViewModifier {
  public var color: Color
  public func body(content: Content) -> some View {
    ZStack {
      VStack {
        color
          .ignoresSafeArea()
          .frame(height: 0)
        Spacer()
      }
      content
    }
  }
}

extension View {
  public func modifyWhiteNavbar(with color: Color = .blue) -> some View {
    return modifier(WhiteNavBarModifier(color: color))
  }
}
