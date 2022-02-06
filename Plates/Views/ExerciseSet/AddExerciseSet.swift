//
//  AddExerciseSet.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-06.
//

import SwiftUI
import CoreData

struct AddExerciseSet: View {
    
    @EnvironmentObject var appSettings: AppSettings
    @Binding var shouldPresentAddNewExerciseSet: Bool
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var selectedExercise: Exercise
    @State var name: String = ""
    @State var notes: String = ""
    @State var weight: Double = 7
    @State var repetitions: Double = 10
    var selectedExerciseSet: ExerciseSet?
    
    @State private var errorMessage = ""
    @State private var shouldShowValidationAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("kHeaderName")) { TextField("kPlaceholderEnterHere", text: $name) }
                Section(header: Text("kHeaderNotes")) { TextField("kPlaceholderEnterHereOptional", text: $notes) }
                Section(header: Text("Weight (\(Int(weight)) kgs)"), footer: Text("Previous: \(previousSetWeight()) kgs")) {
                    Slider(value: $weight, in: 1...100, step: 1)
                }
                Section(header: Text("Repetitions: (\(Int(repetitions)) reps)"), footer: Text("Previous: \(previousSetRep()) reps")) {
                    Slider(value: $repetitions, in: 1...100, step: 1)
                }
            }
                .alert(isPresented: $shouldShowValidationAlert, content: { () -> Alert in
                    Alert(title: Text("kAlertTitleError"), message: Text(errorMessage), dismissButton: .default(Text("kButtonTitleOkay")))
                })
                .navigationBarTitle(Text(selectedExerciseSet == nil ? "kScreenTitleNewSet" : "kScreenTitleEditSet"), displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: { self.validateData() }) { CustomBarButton(title: NSLocalizedString("kButtonTitleSave", comment: "Button title")).environmentObject(appSettings)
                })
        }
    }
    
    func previousSetWeight() -> String {
        if selectedExerciseSet == nil {
            return "\(Int(selectedExercise.wExerciseSets.last?.wWeight ?? 0.0))"
        } else {
            let index = selectedExercise.wExerciseSets.firstIndex { (exSet) -> Bool in
                exSet.wId == selectedExerciseSet?.wId
            }
            if let index = index, index > 0 {
                let previousExset = selectedExercise.wExerciseSets[index - 1]
                return "\(Int(previousExset.wWeight))"
            }
        }
        return "0"
    }
    
    func previousSetRep() -> String {
        if selectedExerciseSet == nil {
            return "\(selectedExercise.wExerciseSets.last?.wRepetitions ?? 0)"
        } else {
            let index = selectedExercise.wExerciseSets.firstIndex { (exSet) -> Bool in
                exSet.wId == selectedExerciseSet?.wId
            }
            if let index = index, index > 0 {
                let previousExset = selectedExercise.wExerciseSets[index - 1]
                return "\(Int(previousExset.wRepetitions))"
            }
        }
        return "0"
    }
    
    /**Dismisses the view*/
    func dismissView() {
        self.shouldPresentAddNewExerciseSet = false
    }
    
    func validateData() {
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            errorMessage = NSLocalizedString("kAlertMsgExerciseSetNameRequired", comment: "Alert message")
            shouldShowValidationAlert.toggle()
        } else {
            saveExerciseSet()
        }
    }
    
    /**Saves the new workout*/
    func saveExerciseSet() {
        if selectedExerciseSet != nil { // Update set flow
            selectedExerciseSet?.name = self.name
            selectedExerciseSet?.notes = self.notes
            selectedExerciseSet?.weight = self.weight
            selectedExerciseSet?.repetitions = Int16(self.repetitions)
        } else { // New set flow
            let newExerciseSet = ExerciseSet(context: managedObjectContext)
            newExerciseSet.name = self.name
            newExerciseSet.notes = self.notes
            newExerciseSet.id = UUID()
//            newExerciseSet.date = Date()
//            newExerciseSet.updatedAt = Date()
            newExerciseSet.weight = self.weight
            newExerciseSet.repetitions = Int16(self.repetitions)
            selectedExercise.addToExerciseSets(newExerciseSet)
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

struct AddExerciseSet_Previews: PreviewProvider {
    
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let exer = Exercise(context: moc)
        exer.name = "Barbell Curl"
        exer.id = UUID()
        
        return AddExerciseSet(shouldPresentAddNewExerciseSet: .constant(true), selectedExercise: exer).environment(\.managedObjectContext, moc).environmentObject(AppSettings())
    }
}
