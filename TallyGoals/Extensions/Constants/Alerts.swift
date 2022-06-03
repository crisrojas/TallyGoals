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
      title: Text("Are you sure you want to delete the item?"),
      message: Text("This action cannot be undone"),
      primaryButton: .destructive(Text("Delete"), action: action),
      secondaryButton: .default(Text("Cancel"))
    )
  }
}
