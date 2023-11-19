//
//  Login.swift
//  mazi
//
//  Created by Ahmed Elsaeed on 18/11/2023.
//

import SwiftUI

struct Login: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var is_loading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
            VStack{
                VStack{
                    TextField("what's ur email?", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .transition(.slide)
                    SecureField("and ur password?", text: $viewModel.password)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .transition(.slide)
                    Button(action: {
                        Task {
                            is_loading = true
                            do {
                                try await viewModel.login()
                                print("I am here")
                            } catch {
                                print("login failed: \(error)")
                            }
                            is_loading = false
                        }
                    })
                    {
                        Text("continue <3")
                    }.buttonStyle(.borderedProminent)
                    .clipShape(Capsule())
                    .transition(.slide)
                    .tint(.indigo)
                    
                }
                NavigationLink(destination: Homepage(), isActive: $viewModel.yalla_navigate) {
                    EmptyView()
                }
            }
            .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Login(viewModel: LoginViewModel())
    }
}
