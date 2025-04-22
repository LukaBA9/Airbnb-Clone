//
//  LogInFormView.swift
//  Airbnb Clone
//
//  Created by Luka on 19.3.25..
//

import SwiftUI

struct LogInFormView<Content: View>: View {
    enum LogInSelection: Int, Identifiable, CaseIterable {
        case sign_in
        case sign_up
        
        var id: Int {
            rawValue
        }
    }
    
    let header: Content
    let showSignUpCaption: Bool
    
    @State private var selection: LogInSelection = .sign_in
    @StateObject var logInViewModel: LogInViewModel = LogInViewModel()
    @StateObject var registerViewModel: RegisterViewModel = RegisterViewModel()
    
    init(showSignUpCaption: Bool = true, @ViewBuilder header: @escaping () -> Content) {
        self.showSignUpCaption = showSignUpCaption
        self.header = header()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 27) {
            header
            //phone number form
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    if selection == .sign_up {
                        TextField("Name", text: $registerViewModel.name)
                            .padding(9)
                            .frame(height: 59)
                            .foregroundStyle(.black)
                            .background(.black.opacity(0.12), in: RoundedRectangle(cornerRadius: 9))
                            .shadow(color: .black.opacity(0.1), radius: 2)
                    }
                    //email address field
                    TextField("Email Address", text: selection == .sign_in ? $logInViewModel.email : $registerViewModel.email)
                        .padding(9)
                        .frame(height: 59)
                        .foregroundStyle(.black)
                        .background(.black.opacity(0.12), in: RoundedRectangle(cornerRadius: 9))
                        .shadow(color: .black.opacity(0.1), radius: 2)
                    //password field
                    SecureField("Password", text: selection == .sign_in ? $logInViewModel.password : $registerViewModel.password)
                        .padding(9)
                        .frame(height: 59)
                        .foregroundStyle(.black)
                        .background(.black.opacity(0.12), in: RoundedRectangle(cornerRadius: 9))
                        .shadow(color: .black.opacity(0.1), radius: 2)
                    if selection == .sign_up {
                        SecureField("Confirm password", text: $registerViewModel.passwordConfirmation)
                            .padding(9)
                            .frame(height: 59)
                            .foregroundStyle(.black)
                            .background(.black.opacity(0.12), in: RoundedRectangle(cornerRadius: 9))
                            .shadow(color: .black.opacity(0.1), radius: 2)
                    }
                    if !logInViewModel.errorMessage.isEmpty || !registerViewModel.errorMessage.isEmpty {
                        Text(selection == .sign_in ? logInViewModel.errorMessage : registerViewModel.errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
                .foregroundStyle(.gray)
                
                if showSignUpCaption {
                    HStack(spacing: 2) {
                        Text(selection == .sign_in ? "Don't have an account?" : "Already have an account?")
                        Button {
                            //change to other selection
                            withAnimation(.snappy(duration: 0.3)) {
                                selection = LogInSelection(rawValue: (selection.rawValue + 1) % LogInSelection.allCases.count)!
                            }
                        } label: {
                            Text(selection == .sign_up ? "Log in" : "Sign up")
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .underline()
                        }
                    }
                    .font(.caption)
                }
            }
            
            //continue button
            Button {
                //
            } label: {
                Button {
                    switch selection {
                    case .sign_in:
                        logInViewModel.login()
                    case .sign_up:
                        registerViewModel.register()
                    }
                } label: {
                    Text(selection == .sign_in ? "Log in" : "Sign up")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(height: 51, alignment: .leading)
                        .background(.pink, in: RoundedRectangle(cornerRadius: 6))
                }

            }
            HStack {
                CustomDivider(width: 0.5, color: .black)
                Text("or")
                    .padding()
                CustomDivider(width: 0.5, color: .black)
            }
            
            VStack(spacing: 27) {
                HStack {
                    Button {
                        
                    } label: {
                        Image("facebook")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .frame(width: 110, height: 51)
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.black)
                            }
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36)
                            .frame(width: 110, height: 51)
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.black)
                            }
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image("apple")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28)
                            .offset(y: -2)
                            .frame(width: 110, height: 51)
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.black)
                            }
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LogInFormView() {
        Text("Log in to book")
            .font(.title2)
            .fontWeight(.semibold)
    }
}
