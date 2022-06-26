//
//  Alerts.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import SwiftUI

extension Alert {
  static func deleteAlert(action: @escaping SimpleAction) -> Alert {
    Alert(
      title: Text("Êtes vous sûr de vouloir éliminer ce compteur?"),
      message: Text("Cette action est définitive"),
      primaryButton: .destructive(Text("Éliminer"), action: action),
      secondaryButton: .default(Text("Cancel"))
    )
  }
}
