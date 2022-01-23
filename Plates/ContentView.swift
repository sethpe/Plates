//
//  ContentView.swift
//  Plates
//
//  Created by Seth Petel on 2022-01-21.
//

import SwiftUI
import HealthKitUI
import HealthKit

struct ContentView: View {
    
    private var healthStore: HealthStore?
    @State private var steps: [Step] = [Step]()
    
    
    init () {
        healthStore = HealthStore()
    }
    
    private func updateUIFromStatistics (_ statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0) /*either we have a number of steps or its 0*/
            , date: statistics.startDate)
            
            steps.append(step) // add all step of each dat
            
        }
        
    }
    
    var body: some View {
       
        Text("PLATES.")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(.black)

        
        NavigationView {
            List(steps, id:\.id) { step in
                NavigationLink {
                    StepDetail()
                } label: {
                    HStack (alignment: .center){
                        Text("\(step.count)")
                            .foregroundColor(.mint)
                            .font(.headline)
                        Text(step.date, style: .date)
                            .opacity(0.5)

                    }
                }
            }
            .navigationTitle("Daily Steps")
        }
        .onAppear {
            if let healthStore = healthStore {
                healthStore.requestAuthorization { success in
                    if success {
                        healthStore.calculateSteps { statisticsCollection in
                            if let statisticsCollection = statisticsCollection {
                                // update the UI
                                updateUIFromStatistics(statisticsCollection)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

