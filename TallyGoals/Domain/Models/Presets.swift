//
//  Presets.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 19/06/2022.
//

import Foundation

struct Preset: Identifiable, Equatable {
  var id: String { name }
  let name: String
  let description: String?
  let isFeatured: Bool
  
  init(
    name: String,
    description: String? = nil,
    isFeatured: Bool = false
  ) {
    self.name = name
    self.description = description
    self.isFeatured = isFeatured
  }
}

struct PresetCategory: Identifiable, Equatable {

  
  let id: UUID
  let emoji: String
  let name: String
  var presets: [Preset]
  
  init(id: UUID = UUID(), emoji: String, name: String, presets: [Preset] = []) {
    self.id = id
    self.emoji = emoji
    self.name = name
    self.presets = presets
  }
}
