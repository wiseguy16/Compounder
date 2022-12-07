//
//  CompundView.swift
//  MFAScraps
//
//

import SwiftUI
import Charts

struct CompoundView: View {
  @State private var initial: Double? = 0
  @State private var adding: Double? = 0
  @State private var inflation: Double? = 0
  @State private var rate: Double? = 0
  @State private var years: Int? = 0
  @State private var results: [String] = []
  @State private var compounds: [Compound] = []
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 8) {
          VStack(alignment: .leading) {
            Text("Initial Amount").padding(.horizontal).padding(.top)
            TextField("initial", value: $initial, format: .number)
              .textFieldStyle(.roundedBorder)
              .keyboardType(.numberPad)
              .padding(.horizontal)
            Text("How much to add each year?").padding(.horizontal)
            TextField("additions", value: $adding, format: .number)
              .keyboardType(.numberPad)
              .textFieldStyle(.roundedBorder)
              .padding(.horizontal)
            Text("Inflation (adjusted to contributions)?").padding(.horizontal)
            TextField("inflation", value: $inflation, format: .number)
              .keyboardType(.decimalPad)
              .textFieldStyle(.roundedBorder)
              .padding(.horizontal)
          }
          VStack(alignment: .leading) {
            Text("What interest rate?").padding(.horizontal)
            TextField("rate", value: $rate, format: .number)
              .textFieldStyle(.roundedBorder)
              .keyboardType(.decimalPad)
              .padding(.horizontal)
            Text("How many years?").padding(.horizontal)
            TextField("years", value: $years, format: .number)
              .textFieldStyle(.roundedBorder)
              .keyboardType(.numberPad)
              .padding(.horizontal)
          }
          HStack {
            Button(action: {
              reset()
            }, label: {
              Text("Reset")
            }).buttonStyle(.borderedProminent)
            
            Spacer()
            Button(action: {
              compounds = []
              makeInterest()
            }, label: {
              Text("Compute")
            }).buttonStyle(.borderedProminent)
          }.padding()
          
          Chart {
            ForEach(compounds, id: \.year) {
              LineMark(
                x: .value("Year", $0.year),
                y: .value("Total", $0.result)
              )
              .interpolationMethod(.catmullRom)
              .symbol(Circle().strokeBorder(lineWidth: 2))
              BarMark(
                x: .value("Year", $0.year),
                y: .value("Adding", $0.adding)
              ).foregroundStyle(Color.green)
            }
          }
          .chartYScale(domain: 0...(compounds.last?.result ?? 100))
          .frame(height: 350)
          .padding(8)
          
          VStack(alignment: .leading) {
            ForEach(results, id: \.self) { val in
              Text(val).padding(.horizontal)
            }
          }.padding()
          
          Chart {
            ForEach(compounds, id: \.year) {
              BarMark(
                x: .value("Year", $0.year),
                y: .value("Total", $0.result)
              )
            }
            
          }
          .frame(height: 350)
          .padding(8)
          
          
        }
      }
      .background(Color(.lightGray).opacity(0.2))
      .navigationTitle("Compounder")
      .onAppear {
        reset()
      }
    }
  }
  
  func makeInterest() {
    guard let rate = rate,
          let initial = initial,
          let years = years,
          let adding = adding else { return }
    let inf = inflation ?? 0
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 2
    
    results = []
    let r = (1 + (rate * 0.01))
    let i = (1 + (inf * 0.01))
    var result = initial
    var tempAdd = adding
    for y in 1...years {
      if y != 1 {
        tempAdd = tempAdd * i
        debugPrint(tempAdd)
      }
      result += tempAdd
      result = result * r
      guard let a = numberFormatter.string(from: result as NSNumber) else { return }
     
      let answer = "Year \(y) total $\(a)"
      
      self.results.append(answer)
      let c = Compound(id: UUID(),
                       initial: initial,
                       adding: tempAdd,
                       inflation: i,
                       rate: r,
                       year: y,
                       result: result,
                       answer: answer)
      compounds.append(c)
      UIApplication.shared.endEditing()
    }
    
  }
  
  func reset() {
    initial = nil
    adding = nil
    rate = nil
    years = nil
    inflation = nil
    results = []
    compounds = []
  }
}

struct Compound: Identifiable {
  var id: UUID = UUID()
  var initial: Double = 0
  var adding: Double = 0
  var inflation: Double = 0
  var rate: Double = 0
  var year: Int = 0
  var result: Double = 0
  var answer: String = ""
  
}

struct CompoundView_Previews: PreviewProvider {
  static var previews: some View {
    CompoundView()
  }
}

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
