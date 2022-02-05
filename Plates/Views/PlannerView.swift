//
//  PlannerView.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-04.
//

import SwiftUI


struct PlannerView: View {
    
    @ObservedObject var workoutStore = WorkoutStore()
    @State var newWorkout = ""
    
    func addNewWorkout () {
        workoutStore.workoutList.append(Workout(id: UUID(), dateCreated: Date(), isFavorite: false, name: newWorkout, notes: ""))
        newWorkout = ""
    }

    var addWorkout: some View {
        HStack{
            TextField("Enter a new workout", text: $newWorkout)
            Button(action: self.addNewWorkout){
                Label("New Workout", systemImage: "cross.fill")
            }
        }
    }
    
    var body: some View {

        NavigationView {
            VStack{
                addWorkout.padding()
                List{
                    ForEach(self.workoutStore.workoutList) { workout in
                        NavigationLink(destination: ExerciseView()){
                            Label(workout.name, systemImage: "flame")
                        }
                        
                    }
                }
                
            }
            .navigationTitle(Text("Workouts"))
            
        }
    }
    
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}

