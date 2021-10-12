//
//  ContentView.swift
//  imUrlDataAppSUI
//
//  Created by AndyDent on 11/10/21.
//

import SwiftUI


struct ContentView: View {
    //TODO change this into a collection and use ForEach to build the VStack
    @State var happyAllowed = true
    @State var quizzicalAllowed = true
    @State var distraughtAllowed = true
    @State var angryAllowed = true
    var happyOpacity: Double {happyAllowed ? 1.0 : 0.3}
    var quizzicalOpacity: Double {quizzicalAllowed ? 1.0 : 0.3}
    var distraughtOpacity: Double {distraughtAllowed ? 1.0 : 0.3}
    var angryOpacity: Double {angryAllowed ? 1.0 : 0.3}
    var body: some View {
        VStack(alignment: .center) {
            Text("Choose moods allowed to send")
            VStack(alignment: .center, spacing: 0) {
                HStack() {
                    Toggle("", isOn: $happyAllowed).labelsHidden()
                    Text("😀").opacity((happyOpacity))
                }
                HStack {
                    Toggle("", isOn: $quizzicalAllowed).labelsHidden()
                    Text("🤨").opacity((quizzicalOpacity))
                }
                HStack {
                    Toggle("", isOn: $distraughtAllowed).labelsHidden()
                    Text("😫").opacity((distraughtOpacity))
                }
                HStack {
                    Toggle("", isOn: $angryAllowed).labelsHidden()
                    Text("😫").opacity((angryOpacity))
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
