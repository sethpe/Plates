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
    @State private var workouts: [HKWorkout] = [HKWorkout]()
    
    
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
       
//        Text("Home.")
//            .font(.largeTitle)
//            .fontWeight(.heavy)
//            .foregroundColor(.black)
        GeometryReader { geometry in
            
            ZStack(alignment: .top){
                Color.white.edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
//                        Spacer(minLength: Constants.navigationBarHeight).frame(width: geometry.size.width, height: Constants.navigationBarHeight, alignment: .top)
                        
                        NavigationView {
                            List(steps, id:\.id) { step in
                                NavigationLink  {
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
                    
                        
                        // Create workout charts
                        
                        self.createCharts()
                    }
                }
            }
            
            
            
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
    func createCharts() -> some View {
         Group {
             // Move Chart
             BarChartView(
                 title: "Move",
                 progress: "330",
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

