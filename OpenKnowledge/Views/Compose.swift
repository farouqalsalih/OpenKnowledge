//
//  Compose.swift
//  OpenKnowledge
//
//  Created by Farouq Alsalih on 12/12/22.
//

import SwiftUI
import CoreData

struct Compose: View {
    @State var prompt:String = ""
    @State var APIResult : String = ""
    @State var done: Bool = true
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var persistData:persist
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.gray)
            ScrollView{
                
    //                .cornerRadius(9)
                VStack{
                    Spacer()
                    
                    if(done){
                        Text(APIResult)
                            .font(.custom("Helvetica", size: 30))
                            .multilineTextAlignment(.center)
                    } else {
                        ProgressView("Please Wait")
                    }
        //            Spacer()
        //            Text("H")
        //            Spacer()
                    TextEditor(text: $prompt)
                        .frame(height: 100)
                        .background(.white)
                        .foregroundColor(.black)
    //                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        Task{
                            done.toggle()
                            await load()
                            done.toggle()
                            hideKeyboard()

                        }
                    }, label: {
                        Text("Generate")
                            .font(.custom("Helvetica", size: 30))
                            .padding()
                    })
                    
                }
            }.onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    func load() async {
        do {
            try await urlResults()
        } catch { print(error) }
    }

    func urlResults() async throws {

        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(persistData.API_KEY)", forHTTPHeaderField: "Authorization")
//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

        var body: [String: Any] = [String:Any]()
        body["model"] = persistData.MODEL
        body["temperature"] = persistData.TEMPERATURE
        body["prompt"] = prompt
        body["max_tokens"] = persistData.MAX_TOKENS
        print(persistData.MAX_TOKENS)
        request.httpBody = try! JSONSerialization.data(withJSONObject: body)

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("error calling POST on OpenAI API")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any]
                print("\(json)")
                
                let choices = json?["choices"] as? [[String: Any]]
                let text = choices?.first?["text"] as? String
                
                let created = json?["created"] as? Int
                
                let id = json?["id"] as? String
//                print(id)
                
//                print("\(created)")
                let usage = json?["usage"] as? [String: Any]
                let completion_tokens = usage?["completion_tokens"] as? Int
                let prompt_tokens = usage?["prompt_tokens"] as? Int
                let total_tokens = usage?["total_tokens"] as? Int

//                print(str!)
                print(text)
                print(created)
                print(id)
                print(completion_tokens)
                print(prompt_tokens)
                print(total_tokens)
                
                if(text == nil || created == nil || id == nil || completion_tokens == nil || prompt_tokens == nil || total_tokens == nil){
                    APIResult = "There was an error in processing your request, please try again at a later time"
                } else {
                    APIResult = "Response: \(text ?? "None")\nPrompt Tokens: \(prompt_tokens ?? 0)\n"
                    
                    withAnimation {
                        let listing = Item(context: viewContext)
                        listing.text = text ?? ""
                        listing.created = (String)(created ?? 0)
                        listing.id = id ?? ""
                        listing.completion = (String)(completion_tokens ?? 0)
                        listing.prompt_t = (String)(prompt_tokens ?? 0)
                        listing.total = (String)(total_tokens ?? 0)


                        listing.date = Date()
                        listing.uuid = UUID()

                        do {
                            try viewContext.save()
                            dismiss()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                        
                        
                        
//                        itemsVM.add(total: (String)(total_tokens ?? 0), text: text ?? "", prompt_t: (String)(prompt_tokens ?? 0), created: (String)(created ?? 0), completion: (String)(completion_tokens ?? 0))
                    }
                }
            } catch {
                print("error trying to decode response data")
                print(error)
            }
            
            
        }
        task.resume()
    }
}

//grabbed online from https://medium.com/@realhouseofcode/swiftui-dismiss-keyboard-on-outside-tap-d3d56894813
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Compose_Previews: PreviewProvider {
    static var previews: some View {
        let a = persist()

        Compose()
            .environmentObject(a)
    }
}
