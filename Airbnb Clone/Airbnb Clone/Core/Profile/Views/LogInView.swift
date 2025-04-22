//
//  LogInView.swift
//  Airbnb Clone
//
//  Created by Luka on 26.3.25..
//

import SwiftUI

struct LogInView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 48) {
                VStack(alignment: .leading, spacing: 21) {
                    LogInFormView(showSignUpCaption: true) {
                        VStack(alignment: .leading, spacing: 9) {
                            Text("Your profile")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Log in or sign up to start planning your next trip")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    LogInTabButtonView(imageName: "gearshape", text: "Settings")
                    LogInTabButtonView(imageName: "accessibility", text: "Accessibility")
                    LogInTabButtonView(imageName: "heart.text.square", text: "Learn about hosting")
                    LogInTabButtonView(imageName: "questionmark.circle", text: "Get help")
                    LogInTabButtonView(imageName: "text.page", text: "Terms of service")
                    LogInTabButtonView(imageName: "text.page", text: "Privacy policy")
                    LogInTabButtonView(imageName: "text.page", text: "Opens source licenses")
                    
                }
                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.top, 30)
        }
    }
}

#Preview {
    LogInView()
}

struct LogInTabButtonView: View {
    let imageName: String
    let text: String
    var body: some View {
        Button {
            //open settings tab
        } label: {
            VStack {
                HStack {
                    Image(systemName: imageName)
                        .font(.title2)
                    Text(text)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.vertical, 9)
                Divider()
            }
            .foregroundStyle(.black)
        }
    }
}
