//
//  Info.swift
//  OpenKnowledge
//
//  Created by Farouq Alsalih on 12/11/22.
//

import SwiftUI

struct Info: View {
    var body: some View {
        VStack {
            Spacer()

            Image("final")
                .resizable()
                .frame(width: 200, height: 200)
            
            Text(Bundle.main.displayName ?? "")
                .font(.largeTitle)
                .fontWeight(.medium)
            Text(Bundle.main.version ?? "")
                .font(.title)
                .fontWeight(.medium)
            Text(Bundle.main.build ?? "")
                .font(.caption)
            Spacer()

            Text(Bundle.main.copyright ?? "")
                .font(.caption2)
        }
        .padding()
        
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Info()
    }
}
