import Algorithms
import ComposableArchitecture
import SwiftUI
import SwiftUItilities
import SwiftWind

struct BehaviourGrid: View {
  
  @State private var page: Int = .zero
  @State private var cellHeight: CGFloat = .zero
  
  let model: [BehaviourEntity]
  let store: AppStore
  

  private let columns = [
    GridItem(.flexible(), spacing: .pinnedCellSpacing),
    GridItem(.flexible(), spacing: .pinnedCellSpacing),
    GridItem(.flexible(), spacing: .pinnedCellSpacing)
  ]
  
  private var tabViewHeight: CGFloat {
    let numberOfRows: CGFloat = 2
    return cellHeight * numberOfRows + .pinnedCellSpacing
  }
  
  private var chunkedModel: [[BehaviourEntity]] {
    model.chunks(ofCount: 6).map(Array.init)
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      
      if model.count > 3 {
      TabView(selection: $page) {
        ForEach(0...chunkedModel.count - 1) { index in
          let chunk = chunkedModel[index]
          grid(model: chunk, viewStore: viewStore)
          .horizontal(.horizontal)
        }
       
      }
      .height(tabViewHeight)
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .overlay(indexView, alignment: .bottomTrailing)
    
      } else {
        grid(
          model: model,
          viewStore: viewStore,
          addFillers: false
        )
        .horizontal(.horizontal)
      }
    }
    .animation(.easeInOut, value: model)
  }
  
  var indexView: some View {
      PagerIndexView(
        currentIndex: page,
        maxIndex: chunkedModel.count - 1
      )
      .x(-.horizontal)
      .y(.s4)
      .displayIf(chunkedModel.count > 1)
  }
  
  func grid(model: [BehaviourEntity], viewStore: AppViewStore, addFillers: Bool = true) -> some View {
    LazyVGrid(columns: columns, alignment: .leading, spacing: .pinnedCellSpacing) {
      ForEach(model) { item in
        BehaviourCard(model: item, viewStore: viewStore)
          .bindHeight(to: $cellHeight)
      }
     
      if addFillers {
        fills(delta: 6 - model.count)
      }
    }
  }
 
  @ViewBuilder
  func fills(delta: Int) -> some View {
    if delta > 0 {
     
      ForEach(1...delta) { _ in
        emptyCell
      }
    }
  }
  
  var emptyCell: some View {
    Color.clear
    .aspectRatio(1, contentMode: .fill)
  }
}

