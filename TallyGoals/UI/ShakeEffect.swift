//
//  ShakeEffect.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 29/05/2022.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
  
  var animatableData: CGFloat
  
  private let const: CGFloat = .s2
  func modifier(_ x: CGFloat) -> CGFloat {
    const * sin(x * .pi * 2)
  }
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    let transform = ProjectionTransform(CGAffineTransform(translationX: const + modifier(animatableData), y: 0))
    return transform
  }
}
