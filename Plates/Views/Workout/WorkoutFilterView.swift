//
//  WorkoutFilterView.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-06.
//

import SwiftUI

struct WorkoutFilterView: View {
    
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var onlyFavourite = false
    @State private var shouldPresentAddNewWorkout: Bool = false
    
    var body: some View {
        NavigationView {
            WorkoutsList(predicate: self.customPredicate(), sortDescriptor: NSSortDescriptor(keyPath: \Workout.dateCreated, ascending: true)) /*.environmentObject(appSettings)*/
                .navigationBarTitle(Text("kScreenTitleWorkouts"))
                .navigationBarItems(leading:
                    Button(action: {
                        Helper.hapticFeedback(style: .soft)
                        withAnimation {
                            self.onlyFavourite.toggle()
                        }
                    }) {
                        Image(systemName: onlyFavourite ? "star.fill" : "star")
                            .imageScale(.large)
                            .foregroundColor(onlyFavourite ? .yellow : .gray)
                            .frame(width: 30, height: 30)
                    }, trailing:
                    Button(action: {
                        self.shouldPresentAddNewWorkout.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(kPrimaryTitleFont)
//                            .foregroundColor(appSettings.themeColorView())
                    }.sheet(isPresented: $shouldPresentAddNewWorkout) {
                        AddWorkout(shouldPresentAddNewWorkout: self.$shouldPresentAddNewWorkout).environment(\.managedObjectContext, self.managedObjectContext)/*.environmentObject(self.appSettings)*/
                    }
            )
        }
    }
    
    /**Creates predicate based on filter values*/
    func customPredicate() -> NSPredicate? {
        if onlyFavourite {
            let predicate = NSPredicate(format: "isFavourite == %@", NSNumber(booleanLiteral: onlyFavourite))
            return predicate
        } else {
            return nil
        }
    }
    
}

struct WorkoutFilterView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutFilterView()
    }
}
