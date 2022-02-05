//
//  Exercise.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-04.
//

import Foundation

struct Exercise: Identifiable {
    
    var name: String
    var weight: Int
    var id = UUID()
    var sets: Int
    
    
}

class ExerciseStore: ObservableObject {
    @Published var exerciseStore = [Exercise]()
}
