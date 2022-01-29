//
//  ContentView.swift
//  Plates
//
//  Created by Seth Petel on 2022-01-21.
//

import SwiftUI
import HealthKit
import SwiftUICharts

struct ContentView: View {
    
    private var healthStore: HealthStore?
    @State private var weeklySteps: [Step] = [Step]()
    @State private var dailySteps: Int = 0
    @State private var stepsList: [Step] = [Step]()
    @State private var dailyStepsData: [Double] = [Double]()
    @State private var workouts: [HKWorkout] = [HKWorkout]()
    
    
    init () {
        healthStore = HealthStore()
    }
    
    private func updateUIFromStepsStatistics (_ statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
//            let cumulativeCount = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: endDate)
            
            stepsList.append(step)

            
//
        }
        
        print(stepsList)
        for s in stepsList {
            print(s.count)
            let currentCount = Double(s.count)
            dailyStepsData.append(currentCount)
            print(dailyStepsData)
        }
        
        for d in dailyStepsData {
            dailySteps += Int(d)
        }
    }
    

    
    var body: some View {

       /* CREATE STEPS GRAPH HERE */
        
        LineChartView(data: dailyStepsData, title: "Daily Steps", legend: "\(dailySteps)", form: ChartForm.large)
        
//        List(stepsList, id:\.id) { step in
//            HStack {
//                Text("\(step.count)")
//                    .foregroundColor(.mint)
//                    .font(.headline)
//                Text(step.date, style: .date)
//                    .opacity(0.5)
//            }
//        }
//
        
//        NavigationView {
//            List(steps, id:\.id) { step in
//                NavigationLink  {
//                    StepDetail()
//                } label: {
//                    HStack (alignment: .center){
//                        Text("\(step.count)")
//                            .foregroundColor(.mint)
//                            .font(.headline)
//                        Text(step.date, style: .date)
//                            .opacity(0.5)
//                    }
//                }
//            }
//            .navigationTitle("Daily Steps")
//        }
        
        GeometryReader { geometry in
            
            ZStack(alignment: .top){
                Color.white.edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        Spacer(minLength: Constants.navigationBarHeight).frame(width: geometry.size.width, height: Constants.navigationBarHeight, alignment: .top)
                        // Create workout charts
                        self.createCharts()
                    }
                }
            }
            
            
            
        }
        
        .onAppear {
            if let healthStore = healthStore {
                healthStore.fetchSteps() { success in
                    if success {
                        healthStore.calculateDailySteps() { statisticsCollection in
                            if let statisticsCollection = statisticsCollection {
                                // update the UI
                                updateUIFromStepsStatistics(statisticsCollection)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    func createCharts() -> some View {
         Group {
             // Move Chart
             BarChartView(
                 title: "Activity",
                 progress: "",
                 goal: "300",
                 total: "2 175 CAL",
                 average: "56",
                 unit: "CAL",
                 data: ActivityData.moveChartData,
                 textColor: Color.moveTextColor,
                 barStartColor: Color.moveBarStartColor,
                 barEndColor: Color.moveBarEndColor
             )
                 .padding([.bottom], 25)
             
             // Exercise Chart
             BarChartView(
                 title: "Exercise",
                 progress: "22",
                 goal: "30",
                 total: "8H 42M",
                 average: "11",
                 unit: "MIN",
                 data: ActivityData.exerciseChartData,
                 textColor: Color.exerciseTextColor,
                 barStartColor: Color.exerciseBarStartColor,
                 barEndColor: Color.exerciseBarEndColor
             )
                 .padding([.bottom], 25)
             
             // Stand Chart
//             StandChartView(
//                 title: "Stand",
//                 progress: "10",
//                 goal: "12",
//                 idle: "0",
//                 unit: "HRS",
//                 data: ActivityData.standChartData,
//                 textColor: Color.standTextColor,
//                 barStartColor: Color.standBarStartColor,
//                 barEndColor: Color.standBarEndColor
//             )
//                 .padding([.bottom], 25)
         }
     }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

