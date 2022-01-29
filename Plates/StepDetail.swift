//
//  StepDetail.swift
//  Plates
//
//  Created by Seth Petel on 2022-01-23.
//

import Foundation
import SwiftUI
import HealthKit

import SwiftUI


struct StepDetail: View {
    
    private var healthStore: HealthStore?
    @State private var weeklySteps: [Step] = [Step]()
    
    
    init () {
        healthStore = HealthStore()
    }
    
    
    private func updateUIFromStatistics (_ statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0) /*either we have a number of steps or its 0*/
                            , date: statistics.startDate)
            
            weeklySteps.append(step) // add all step of each dat
            
        }
        
    }

    var body: some View {
        

        NavigationView {
            
            List(weeklySteps, id: \.id){ step in
                
                HStack (alignment: .center){
                    Text("\(step.count)")
                        .foregroundColor(.mint)
                        .font(.headline)
                    Text(step.date, style: .date)
                        .opacity(0.5)
                }
                
            }
            .navigationTitle("Weekly Steps")
        }

        .onAppear {
            if let healthStore = healthStore {
                healthStore.fetchSteps() { success in
                    if success {
                        healthStore.calculateDailySteps() { statisticsCollection in
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


struct StepDetail_Previews: PreviewProvider {

    static var previews: some View {

        StepDetail()

    }

}

