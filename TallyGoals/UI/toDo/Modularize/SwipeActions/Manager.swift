//
//  Manager.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import Combine
import SwiftUI

final class SwipeManager: ObservableObject {
  
  @Published var swipingId: UUID?
  @Published var rowIsOpened: Bool = false
  
  var cancellables = Set<AnyCancellable>()
  
  static let shared = SwipeManager()
  private init() {}
  
  func collapse() {
    rowIsOpened = false
  }
}
