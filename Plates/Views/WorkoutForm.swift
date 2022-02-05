//
//  WorkoutForm.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-04.
//

import Foundation
import SwiftUI

struct WorkoutFormView: View {
    
    @State var name = ""
    @State var notes = ""
//    @Environment(\.managedObjectContext) var managedObjectContext
//    @Binding var shouldPresentAddNewWorkout: Bool
    @State var workoutToEdit: Workout?
//    let workoutStore = 
    
    var body: some View{
        Form{
            Section(header: Text("New Workout")) { TextField("Workout Name", text: $name) }
            Section(header: Text("Notes")) { TextField("Enter here (optional", text: $notes)}
        }
    }
    
    
    func validate() {
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.isEmpty {
            
        } else {
            saveWorkout()
        }
    }
   
    
    func saveWorkout() {
        
     }
     
 
    
    
}

struct WorkoutFormView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutFormView()
    }
}
