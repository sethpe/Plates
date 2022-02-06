//
//  Constants.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-05.
//

import Foundation
import SwiftUI
    
let kShadowRadius: CGFloat = 3.0
let kCornerRadius: CGFloat = 15.0
let kDefaultValue = "-"
let kCommonListIndex = 9999
let kOneHour: Int16 = 3600
let kOneMinute: Int16 = 60
let kDeviceWorkoutBrightness: CGFloat = 0.5
let kTimePeriodAllOptionValue = 999

let kPrimaryTitleFont = Font.system(.title, design: .rounded)
let kPrimaryLargeTitleFont = Font.system(.largeTitle, design: .rounded)
let kPrimaryBodyFont = Font.system(.body, design: .rounded)
let kPrimaryHeadlineFont = Font.system(.headline, design: .rounded)
let kPrimarySubheadlineFont = Font.system(.subheadline, design: .rounded)
let kPrimaryFootnoteFont = Font.system(.footnote, design: .rounded)
let kPrimaryCalloutFont = Font.system(.callout, design: .rounded)
let kPrimaryCaptionFont = Font.system(.caption, design: .rounded)

let kPrimaryListCellOpacity = 0.2
let kPrimaryBackgroundColour = Color.secondary.opacity(kPrimaryListCellOpacity)
let kFavStarColour = Color.yellow


enum WorkoutCategory: String, CaseIterable {
    case arms = "Arms"
    case push = "Push"
    case abs = "Abs"
    case pull = "Pull"
    case legs = "Legs"
    case fullBody = "Full Body"
    case cardio = "Cardio"
    case other = "Other"
}



