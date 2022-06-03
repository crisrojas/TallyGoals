//
//  EmojiField.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import SwiftUI

struct EmojiField: View {
  @Binding var text: String
  let placeholder: String
  
  init(
    _ placeholder: String,
    text: Binding<String>
  ) {
    self._text = text
    self.placeholder = placeholder
  }
  
  var body: some View {
    TextField("Emoji", text: $text)
      .onChange(of: text) { newValue in
        text = String(newValue.prefix(1))
      }
  }
}
