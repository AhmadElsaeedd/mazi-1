//
//  ContentView.swift
//  mazi
//
//  Created by Ahmed Elsaeed on 18/11/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack {
                Greeting()//put this at the top of the screen
                Spacer()
                Login(viewModel: LoginViewModel())//put this in the middle of the screen
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
