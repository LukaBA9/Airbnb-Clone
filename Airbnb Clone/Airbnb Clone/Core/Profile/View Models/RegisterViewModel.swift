//
//  RegisterViewModel.swift
//  Airbnb Clone
//
//  Created by Luka on 28.3.25..
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel: ObservableObject {
    @Published var name = "Luka"
    @Published var email = "lm@gmail.com"
    @Published var password = "LLLLLL"
    @Published var passwordConfirmation = "LLLLLL"
    @Published var errorMessage: String = ""
    
    init() {}
    
    func register() {
        guard validate() else {
            return
        }
        print("Init")
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let user = result?.user.uid else {
                return
            }
            
            self?.insertUserRecord(id: user)
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id,
                           name: name,
                           email: email)
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
        print("Setting user record...")
        //Global.main.currentUser = newUser
    }
    
    private func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !passwordConfirmation.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all the fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter valid email."
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long."
            return false
        }
        
        guard password == passwordConfirmation else {
            errorMessage = "Passwords do not match."
            return false
        }
        return true
    }
}
