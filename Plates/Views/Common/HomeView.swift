//
//  HomeView.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-04.
//

import Foundation
import SwiftUI
import SwiftUICharts
import HealthKit

struct HomeView: View {
    
    @EnvironmentObject var appSettings: AppSettings
    // Variables for setup
    private var healthStore: HealthStore?
    // steps
    @State private var weeklySteps: [Step] = [Step]()
    @State private var dailySteps: Int = 0
    @State private var stepsList: [Step] = [Step]()
    @State private var dailyStepsData: [Double] = [Double]()
    @State private var workouts: [HKWorkout] = [HKWorkout]()
    //HR
    @State private var dailyHRData: [Double] = [Double]()
    
    
    init () {
        healthStore = HealthStore()
    }
    
    
    // STEPS
    private func updateUIFromStepsStatistics (_ statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: endDate)
            stepsList.append(step)
        }
//        print(stepsList)
        for s in stepsList {
//            print(s.count)
            let currentCount = Double(s.count)
            dailyStepsData.append(currentCount)
//            print(dailyStepsData)
        }
        
        for d in dailyStepsData {
            dailySteps += Int(d)
        }
    }
    
    // HR DATA
    private func updateHRUI (_ statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            let count = statistics.averageQuantity()?.doubleValue(for: .init(from: "count/s"))
            let avgHRPerSecond = Double(count ?? 0)
            let avgTenMinuteHR = Double(avgHRPerSecond * 60)
            dailyHRData.append(avgTenMinuteHR)
            
        }
        print(dailyHRData)
    }
    

    
    var body: some View {
        VStack{
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)

           /* CREATE STEPS GRAPH HERE */
            LineChartView(data: dailyStepsData, title: "Daily Steps", legend: "\(dailySteps)", form: ChartForm.large)
                .padding()
            
            
            // Heart Rate chart
            BarChartView(data: ChartData(points: dailyHRData), title: "Heart Rate", style: Styles.barChartMidnightGreenLight, form: ChartForm.extraLarge)
        }
        
        
//a
        
        .onAppear {
            if let healthStore = healthStore {
                healthStore.fetchSteps() { success in
                    if success {
                        // CALCULATE DAILY STEPS
                        healthStore.calculateDailySteps() { statisticsCollection in
                            if let statisticsCollection = statisticsCollection {
                                // update the UI
                                updateUIFromStepsStatistics(statisticsCollection)
                            }
                        }
                       
                        
                    }
                }
                healthStore.requestHRData() { success in
                    if success {
                        // CALCULATE HEART RATE FOR THE DAY
                        healthStore.fetchHRData() { hrStatisticsCollection in
                            if let hrStatisticsCollection = hrStatisticsCollection {
                                updateHRUI(hrStatisticsCollection)
                            }
                        }
                    }
                }
            }
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AppSettings())
    }
}
