//
//  Workout.swift
//  Plates
//
//  Created by Seth Petel on 2022-01-23.
//

import Foundation


struct Workout: Identifiable {
    
    let id = UUID()
    let date: Date
    let workout: String
    let ratedDifficulty: Int
    
    
}
