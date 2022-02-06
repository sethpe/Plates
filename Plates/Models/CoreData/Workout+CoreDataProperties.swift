//
//  Workout+CoreDataProperties.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-06.
//
//

import Foundation
import CoreData


extension Workout: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var category: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var exercises: NSSet?
    
    var wName: String { name ?? kDefaultValue }
        var wNotes: String { notes ?? kDefaultValue }
        var wCreatedAt: Date { dateCreated ?? Date() }
        var wId: UUID { id ?? UUID() }
        var wIsFavourite: Bool { isFavorite }
        var wCategory: WorkoutCategory { WorkoutCategory(rawValue: category ?? kDefaultValue) ?? WorkoutCategory.other }
        var wExercises: [Exercise] {
            let set = exercises as? Set<Exercise> ?? []
            return set.sorted {
                $0.displayOrder < $1.displayOrder
            }
        }

}

extension Workout  {
    @objc(addExercisesObject:)
        @NSManaged public func addToExercises(_ value: Exercise)

        @objc(removeExercisesObject:)
        @NSManaged public func removeFromExercises(_ value: Exercise)

        @objc(addExercises:)
        @NSManaged public func addToExercises(_ values: NSSet)

        @objc(removeExercises:)
        @NSManaged public func removeFromExercises(_ values: NSSet)
}
