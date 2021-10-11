//
//  ContentView.swift
//  imUrlDataAppSUI
//
//  Created by AndyDent on 11/10/21.
//

import SwiftUI

struct ContentView: View {
    @State var happyAllowed = true
    @State var quizzicalAllowed = true
    @State var distraughtAllowed = true
    @State var angryAllowed = true
    var body: some View {
        VStack(alignment: .center) {
            Text("Choose moods allowed to send")
            VStack(alignment: .center, spacing: 0) {
                HStack() {
                    Toggle("", isOn: $happyAllowed).labelsHidden()
                    Text("😀")
                }
                HStack {
                    Toggle("", isOn: $quizzicalAllowed).labelsHidden()
                    Text("🤨")
                }
                HStack {
                    Toggle("", isOn: $distraughtAllowed).labelsHidden()
                    Text("😫")
                }
                HStack {
                    Toggle("", isOn: $angryAllowed).labelsHidden()
                    Text("😫")
                }
            }
            .font(Font.system(size: 80.0))
            Button("Send Message from App", action: {})
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
