//
//  ExerciseSet+CoreDataProperties.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-06.
//
//

import Foundation
import CoreData


extension ExerciseSet: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSet> {
        return NSFetchRequest<ExerciseSet>(entityName: "ExerciseSet")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var repetitions: Int16
    @NSManaged public var weight: Double
    @NSManaged public var exercise: Exercise?
    
    var wId: UUID { id ?? UUID() }
        var wName: String { name ?? kDefaultValue }
        var wNotes: String { notes ?? kDefaultValue }
        var wWeight: Double { weight }
        var wRepetitions: Int16 { repetitions }
        var wExercise: Exercise { exercise ?? Exercise() }

}
