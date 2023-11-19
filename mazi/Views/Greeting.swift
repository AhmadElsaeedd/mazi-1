//
//  Greeting.swift
//  mazi
//
//  Created by Ahmed Elsaeed on 18/11/2023.
//

import SwiftUI

struct Greeting: View {
    var body: some View {
        VStack{
            Text("hi, in mazi")
            .font(.title)
            .fontWeight(.bold)
            Text("i'll help u journal, easy")
        }
    }
}

struct Greeting_Previews: PreviewProvider {
    static var previews: some View {
        Greeting()
    }
}
