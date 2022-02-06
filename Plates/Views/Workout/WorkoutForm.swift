//
//  WorkoutForm.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-06.
//

import SwiftUI
import CoreData

struct AddWorkout: View {
    
    @EnvironmentObject var appSettings: AppSettings
    @Binding var shouldPresentAddNewWorkout: Bool
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var name: String = ""
    @State var notes: String = ""
    @State var categoryIndex = 0
    var workoutToEdit: Workout?
    
    @State private var errorMessage = ""
    @State private var shouldShowValidationAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("kHeaderName")) { TextField("kPlaceholderEnterHere", text: $name) }
                Section(header: Text("kHeaderNotes")) { TextField("kPlaceholderEnterHereOptional", text: $notes) }
                Section(header: Text("kHeaderChooseBodyPart")) {
                    Picker("kPlaceholderBodyPart", selection: $categoryIndex) {
                        ForEach(0..<WorkoutCategory.allCases.count, id: \.self) { index in
                            Text(WorkoutCategory.allCases[index].rawValue)
                        }
                    }
                }
            }
                .alert(isPresented: $shouldShowValidationAlert, content: { () -> Alert in
                    Alert(title: Text("kAlertTitleError"), message: Text(errorMessage), dismissButton: .default(Text("kButtonTitleOkay")))
                })
                .navigationBarTitle(Text(workoutToEdit == nil ? "kScreenTitleNewWorkout" : "kScreenTitleEditWorkout"), displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: { self.validateData() }) { CustomBarButton(title: NSLocalizedString("kButtonTitleSave", comment: "Button title"))/*.environmentObject(appSettings)*/
                })
        }
        
    }
    
    /**Dismisses the view*/
    func dismissView() {
        self.shouldPresentAddNewWorkout = false
    }
    
    func validateData() {
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.isEmpty {
            errorMessage = NSLocalizedString("kAlertMsgWorkoutNameRequired", comment: "Alert message")
            shouldShowValidationAlert.toggle()
        } else {
            saveWorkout()
        }
    }
    
    /**Saves the new workout*/
    func saveWorkout() {
        if workoutToEdit != nil { // Update workout flow
            workoutToEdit?.name = self.name
            workoutToEdit?.notes = self.notes
            workoutToEdit?.category = WorkoutCategory.allCases[categoryIndex].rawValue
        } else { // New workout flow
            let newWorkout = Workout(context: managedObjectContext)
            newWorkout.name = self.name
            newWorkout.notes = self.notes
            newWorkout.category = WorkoutCategory.allCases[categoryIndex].rawValue
            newWorkout.id = UUID()
            newWorkout.dateCreated = Date()
//            newWorkout.updatedAt = Date()
            newWorkout.isFavorite = false
        }
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                dismissView()
            } catch {
                print(error)
            }
        }
    }
    
}

struct AddWorkout_Previews: PreviewProvider {
    let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        AddWorkout(shouldPresentAddNewWorkout: .constant(false))
    }
}
