//
//  HealthStore.swift
//  Plates
//
//  Created by Seth Petel on 2022-01-21.
//

import Foundation
import HealthKit
import CoreLocation


extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier:
            .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}


class HealthStore {
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
   
    init(){
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func fetchSteps(completion: @escaping (Bool) -> Void){
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, failure) in
            completion(success)
            
        }
    }
    
    func fetchHRData(completion: @escaping (HKStatisticsCollection?) -> Void){
        let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
        let startDate = Calendar.current.startOfDay(for: Date()) // start date is a 12 am
        let anchorDate = Date.mondayAt12AM()
        
        let interval = DateComponents(hour: 1) // interval of step counting is 30 minutes
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate) // we are searching from start date to anchorDate
        
        query = HKStatisticsCollectionQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval)
        
        query!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }

        if let healthStore = healthStore , let query = self.query {
            healthStore.execute(query)
        }
    }
    
    func calculateDailySteps (completion: @escaping (HKStatisticsCollection?) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let startDate = Calendar.current.startOfDay(for: Date()) // start date is a 12 am
        let anchorDate = Date.mondayAt12AM()
        
        let interval = DateComponents(hour: 1) // interval of step counting is 30 minutes
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate) // we are searching from start date to anchorDate
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval)
        
        query!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }

        if let healthStore = healthStore , let query = self.query {
            healthStore.execute(query)
        }
    }
    
   
    
    func calculateWeeklySteps (completion: @escaping (HKStatisticsCollection?) -> Void){
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! // specifies that we want step count
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) // start date is a week ago
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1) // interval of step counting is daily
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate) // we are searching from start date to anchorDate
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        if let healthStore = healthStore , let query = self.query {
            healthStore.execute(query)
        }
    }
    
    
//    func readWorkouts() async -> [HKWorkout]? {
//        let cycling = HKQuery.predicateForWorkouts(with: .cycling)
//
//        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
//            healthStore!.execute(HKSampleQuery(sampleType: .workoutType(), predicate: cycling, limit: HKObjectQueryNoLimit,sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
//                if let hasError = error {
//                    continuation.resume(throwing: hasError)
//                    return
//                }
//
//                guard let samples = samples else {
//                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
//                }
//
//                continuation.resume(returning: samples)
//            }))
//        }
//
//        guard let workouts = samples as? [HKWorkout] else {
//            return nil
//        }
//
//        return workouts
//    }
//
//    func getLocationDataForRoute(givenRoute: HKWorkoutRoute) async -> [CLLocation] {
//        let locations = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLLocation], Error>) in
//            var allLocations: [CLLocation] = []
//
//            // Create the route query.
//            let query = HKWorkoutRouteQuery(route: givenRoute) { (query, locationsOrNil, done, errorOrNil) in
//
//                if let error = errorOrNil {
//                    continuation.resume(throwing: error)
//                    return
//                }
//
//                guard let currentLocationBatch = locationsOrNil else {
//                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
//                }
//
//                allLocations.append(contentsOf: currentLocationBatch)
//
//                if done {
//                    continuation.resume(returning: allLocations)
//                }
//            }
//
//            healthStore!.execute(query)
//        }
//
//        return locations
//    }


}
