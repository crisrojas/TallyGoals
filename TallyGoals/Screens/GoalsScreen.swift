import ComposableArchitecture
import SwiftUI

struct GoalRow: View {
  
  @State var done: Int = .zero
  let goal: Int = 20
  
  private var goalLabel: String {
    done.string + " / " + goal.string
  }
  
  private var progression: Double {
    Double(done) / Double(goal)
  }
  
  var body: some View {
    
    VStack {
      HStack {
        Text("⏰")
        
        Text("Levantarse a las 7:00 AM")
        
        
        Spacer()
        Text(goalLabel)
        
      }
      .font(.caption)
      
      GeometryReader { geo in
        Rectangle()
          .foregroundColor(Color(UIColor.secondarySystemBackground))
          .height(1)
          .overlay(
            Rectangle()
              .width(geo.size.width * progression)
              .foregroundColor(.blue300)
              .height(1),
            alignment: .leading
          )
      }
    }
    //.vertical(8)
    .onTap {
      withAnimation { done += 1 }
    }
    .buttonStyle(.plain)
    
  }
}

struct LongTermGoalRow: View {
  
  @State var done: Int = .zero
  let goal: Int = 80
  
  private var goalLabel: String {
    done.string + " / " + goal.string
  }
  
  private var progression: Double {
    Double(done) / Double(goal) 
  }
  
  private var level: Int {
    Int(Double(done) / Double(goal) * 10) 
  }
  
  var body: some View {
    HStack {
      Circle()
        .stroke(
          style: StrokeStyle(
            lineWidth: 2.0, 
            lineCap: .round, 
            lineJoin: .round)
        )
        .foregroundColor(Color.defaultBackground)
        .size(50)
        .overlay(
          Image(level.string)
            .resizable()
            .size(40)
            .clipShape(Circle())
        )
        .overlay(
          Circle()
            .trim(
              from: 0.0, 
              to: CGFloat(min(progression, 1.0)
                         )
            )
            .stroke(
              style: StrokeStyle(
                lineWidth: 2.0, 
                lineCap: .round, 
                lineJoin: .round)
            )
            .foregroundColor(.blue300)
            .rotationEffect(Angle(degrees: 270.0))
          
        )
      
      
      Text("💧 Behaviour name")
      
      Spacer()
      
      Text(goalLabel)
    }
    .font(.caption)
    .onTap {
      withAnimation {
        done += 1
      }
    }
    .buttonStyle(.plain)
  }
  
  var levelBadge: some View {
    Text("Lvl \(level)")
      .fontWeight(.bold)
      .font(.caption2)
      .foregroundColor(.blue300)
      .horizontal(4)
      .background(
        Color(UIColor.secondarySystemBackground)
          .cornerRadius(12)
      )
      .x(4)
      .y(4)
  }
}

struct GoalsScreen: View {
  @State var selection: Int = .zero
  let store: AppStore
  
  var body: some View {
    WithViewStore(store) { viewStore in
      
      LazyVStack {
        
        Picker("What is your favorite color?", selection: $selection) {
          
          Text("Short term").tag(0)
          Text("Long term").tag(1)
          
        }
        .pickerStyle(.segmented)
        .bottom(24)
        
        switch selection {
        case 0:
          ForEach(1...10, id: \.self) { int in
            GoalRow()
          }
        case 1:
          ForEach(1...10, id: \.self) { int in
            LongTermGoalRow()
          }
        default: EmptyView()
        }
        
        
        
      }
      .horizontal(24)
      .bottom(24)
      .scrollify()
      
      
    }
    .navigationTitle("Goals")    
    .toolbar {
      Image(systemName: "plus")
        .onTap(navigateTo: AddGoalScreen(store: store)) 
    }
  }
  
  
}

struct AddGoalScreen: View {
  
  @State var count: Int = .zero
  
  let store: AppStore
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        HStack {
          Text("Goal")
          Spacer()
          Text("-")
            .onTap(perform: decrease)
          Text(count.string)
          Text("+")
            .onTap(perform: increment)
        }
        Spacer()
      }
      .horizontal(8)
      .toolbar {
        Text("Save")
          .onTap {
            print("tapped saved button")
          }
          .disabled(true)
      }
      
    }
  }
  
  func decrease() {
    guard count > 0 else { return }
    count -= 1
  }
  
  func increment() {
    count += 1
  }
}
