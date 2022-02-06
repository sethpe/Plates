//
//  Helper.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-05.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

class Helper: NSObject{
    
    class func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .rigid) {
            if AppSettings.isHapticEnabled() {
                let generator = UIImpactFeedbackGenerator(style: style)
                generator.impactOccurred()
            }
        }
    
    class func createDefaultWorkouts() {
        if let count = checkWorkoutsCount(), count > 0 {
            return
        }
        
        let appSettings = AppSettings()
        if !appSettings.addedDefaultWorkouts { 
            let exampleWorkouts = ["Sample workout"]
            let exampleExercises = [["Sample exercise"]]
            let moc = PersistenceController.shared.container.viewContext
                       
           for (index, eWorkout) in exampleWorkouts.enumerated() {
               let workout = Workout(context: moc)
               workout.name = eWorkout
               workout.notes = "\"This is the sample workout to get the taste of this tracker app. Delete this workout and configure your workouts and exercises to get started.\""
               workout.category = WorkoutCategory.arms.rawValue
               workout.id = UUID()
               workout.dateCreated = Date()
               if index == 0 {
                   workout.isFavorite = true
               }
               
               for (_, name) in exampleExercises[index].enumerated() {
                   let exercise = Exercise(context: moc)
                   exercise.name = name
                   exercise.workout?.category = workout.category
                   exercise.id = UUID()
                   
                   for j in 1...3 {
                       let newExerciseSet = ExerciseSet(context: moc)
                       newExerciseSet.name = "Set \(j)"
                       newExerciseSet.id = UUID()
                       newExerciseSet.weight = Double(5 * j)
                       newExerciseSet.repetitions = 12
                       
                       exercise.addToExerciseSets(newExerciseSet)
                   }
                   
                   workout.addToExercises(exercise)
               }
               if moc.hasChanges {
                   do {
                       try moc.save()
//                               appSettings.addedDefaultWorkouts = true
                   } catch {
                       print(error.localizedDescription)
                   }
               }
           }
    }
               }
    
    class func checkWorkoutsCount() -> Int? {
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Workout.entity().name ?? "Workout")
         do {
             let count = try PersistenceController.shared.container.viewContext.count(for: fetchRequest)
             return count
         } catch {
             return nil
         }
     }
    
    
}
