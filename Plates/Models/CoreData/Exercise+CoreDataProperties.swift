//
//  Exercise+CoreDataProperties.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-06.
//
//

import Foundation
import CoreData


extension Exercise: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var workout: Workout?
    @NSManaged public var exerciseSets: NSSet?
    @NSManaged public var displayOrder: Int16

    var wDateCreated: Date { dateCreated ?? Date()}
    var wId: UUID { id ?? UUID()}
    var wIsFavorite: Bool { isFavorite  }
    var wName: String { name ?? "" }
    var wNotes: String { notes ?? "Exercise notes" }
    var wWorkout: Workout { workout ?? Workout()}
    var wExerciseSets: [ExerciseSet] {
            let set = exerciseSets as? Set<ExerciseSet> ?? []
            return set.sorted {
                $0.name ?? "" < $1.name ?? ""
            }
        }

}

extension Exercise  {

    @objc(addExerciseSetsObject:)
        @NSManaged public func addToExerciseSets(_ value: ExerciseSet)

        @objc(removeExerciseSetsObject:)
        @NSManaged public func removeFromExerciseSets(_ value: ExerciseSet)

        @objc(addExerciseSets:)
        @NSManaged public func addToExerciseSets(_ values: NSSet)

        @objc(removeExerciseSets:)
        @NSManaged public func removeFromExerciseSets(_ values: NSSet)
}
