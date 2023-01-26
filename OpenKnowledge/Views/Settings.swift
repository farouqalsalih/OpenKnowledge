//
//  Settings.swift
//  OpenKnowledge
//
//  Created by Farouq Alsalih on 12/11/22.
//

import SwiftUI
import UIKit

struct Settings: View {
    let original_API_KEY = "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"
    
    @State public var model:String = "text-davinci-003"
    @State var temperature:Double = 1
    @State var max_tokens:Double = 1700
    @State var api_key:String = "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"
    @State var buttonText:String = "Copy to Clipboard"
    private let pasteboard = UIPasteboard.general
    @EnvironmentObject var persistData:persist
    let items = ["text-davinci-003", "text-davinci-002", "text-curie-001", "text-babbage-001", "text-ada-001"]
    @State var tokens:Double = 1700
    @State var showActionSheet:Bool = false
    
    var body: some View {
        Form{
            Text("API Key Provided: \n\(original_API_KEY)")
            //Received help from: https://github.com/indently/CopyTextToClipboard/blob/main/CopyTextToClipboard/ContentView.swift
            HStack {
                Button {
                    copyToClipboard()
                } label: {
                    Label(buttonText, systemImage: "doc.on.doc.fill")
                }
                .tint(.orange)
                Spacer()
            }
            
            Section("Enter an API Key:"){
                TextField("Type API Key", text: $api_key)
                    .onAppear(){
                        self.api_key = self.persistData.API_KEY
                    }
                
            }
            
            Section("Select Model"){
                Picker("Model", selection: $model){
                    ForEach(items, id: \.self){
                        Text($0)
                    }
                }.pickerStyle(.wheel)
                .onChange(of: model) { text in
                    if(model == "text-davinci-003"){
                        tokens = 3700
                    } else {
                        tokens = 1700
                        if(max_tokens > 1700) {
                            max_tokens = 1700
                        }
                    }

                }
                .onAppear(){
                    self.model = self.persistData.MODEL
                }
            }
            
            Section("Temperature (How created and varied the responses are):"){
                Slider(value: $temperature, in: 0...1, step: 0.1)
                    .onAppear(){
                        self.temperature = self.persistData.TEMPERATURE
                    }
            }
            
            Section("Max Tokens (There are 90,000 available tokens in the API Key provided above, and each response can take anywhere from 10 to 4096 tokens):"){
                Slider(value: $max_tokens, in: 2...tokens, step: 2)
                    .onAppear(){
                        self.max_tokens = self.persistData.MAX_TOKENS
                    }
            }
            
            Section("Save"){
                Button(action: {
                    showActionSheet = true
                }, label: {
                    HStack{
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }).actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Are you sure you want to save your changes? This will erase your previous settings"),
                                message: Text("Clicking 'Yes' will permanently delete all entries"),
                                buttons: [
                                    .cancel(),
                                    .destructive(
                                        Text("Save"),
                                        action: {
                                            self.persistData.MAX_TOKENS = max_tokens
                                            self.persistData.TEMPERATURE = temperature
                                            self.persistData.API_KEY = api_key
                                            self.persistData.MODEL = model
                                        }
                                    ),
                                    .default(
                                        Text("Don't save")
                                    )
                                ]
                    )
                }
            }
            
            
        }
    }
        
    //Received help from: https://github.com/indently/CopyTextToClipboard/blob/main/CopyTextToClipboard/ContentView.swift
    func copyToClipboard() {
        pasteboard.string = self.original_API_KEY
        
        self.buttonText = "Copied!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.buttonText = "Copy to clipboard"
        }
    }
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        let a = persist()

        Settings()
            .environmentObject(a)
            .preferredColorScheme(.dark)


    }
}
