//
//  Steps.swift
//  Plates
//
//  Created by Seth Petel on 2022-01-23.
//

import Foundation

struct Step: Identifiable  {
    let id = UUID()
    let count: Int
    let date: Date
}
