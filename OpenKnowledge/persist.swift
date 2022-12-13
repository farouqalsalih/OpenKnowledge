//
//  persist.swift
//  Open Knowledge
//
//  Created by Farouq Alsalih on 12/12/22.
//

import Foundation

import SwiftUI

class persist : ObservableObject{
    @AppStorage("MODEL_KEY") var MODEL:String = "text-davinci-003"
    @AppStorage("TEMPERATURE_KEY") var TEMPERATURE:Double = 1
    @AppStorage("MAX_TOKENS_KEY") var MAX_TOKENS:Double = 1700
    @AppStorage("API_KEY_KEY") var API_KEY:String = "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"
}
