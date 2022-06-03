import SwiftUI

struct LegacyBehaviourCaroussel: View {
  
  let model: [Behaviour]
  let store: AppStore
  
  var body: some View {
    
    if model.isEmpty {
      EmptyView()
    } else {
      VStack {
        
        HStack {
          
          Spacer()
          Text("See all")
        }
        .horizontal(24)
        
        HStack(spacing: 12) {
          
          ForEach(model) { item in
            
            LegacyBehaviourCard(
              model: item, 
              store: store
            )
              .leading(item == model.first ? 24 : 0)
              .trailing(item == model.last ? 24 : 0)
          }
        }
        .top(10)
        .scrollify(.horizontal)
      }
    }
  }
}
