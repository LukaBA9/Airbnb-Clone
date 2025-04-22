//
//  LogInViewModel.swift
//  Airbnb Clone
//
//  Created by Luka on 27.3.25..
//

import Foundation
import FirebaseAuth

class LogInViewModel : ObservableObject {
    @Published var password: String = "LLLLLL"
    @Published var email: String = "lm@gmail.com"
    @Published var errorMessage: String = ""
    
    init() {}
    
    func login() {
        guard validateLogin() else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password)
    }
    private func validateLogin() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all the fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter valid email."
            return false
        }
        
        return true
    }
}
