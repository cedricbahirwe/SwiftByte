//
//  AuthorEditor.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 17/01/2023.
//

import SwiftUI

extension CreatorView {
    struct AuthorEditor: View {
        init(isShown: Binding<Bool>,
             author: SBAuthor?,
             completion: @escaping (SBAuthor) -> Void) {
            self._showAuthor = isShown
            self.firstName = author?.firstName ?? ""
            self.lastName = author?.lastName ?? ""
            self.email = author?.email ?? ""
            self.completion = completion
        }

        @Binding private var showAuthor: Bool
        @State private var firstName: String
        @State private var lastName: String
        @State private var email: String

        var completion: (SBAuthor) -> Void


        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("Add Author")
                        .font(.title2.weight(.bold))

                    Button {
                        withAnimation {
                            showAuthor.toggle()
                        }
                    } label: {
                        Label(showAuthor ? "Hide" : "Show", systemImage: "chevron.\(showAuthor ? "up" : "down").circle.fill")
                            .symbolRenderingMode(.hierarchical)

                    }

                    Spacer()
                }

                if showAuthor {
                    VStack(alignment: .leading) {
                        HStack {

                            TextField("First name", text: $firstName)
                                .applyField()
                            TextField("Last name", text: $lastName)
                                .applyField()
                        }

                        HStack {
                            TextField("Email", text: $email)
                                .applyField()
                            Button("Save", action: saveAuthor)
                                .bold()
                        }
                    }
                }
            }

        }

        private func saveAuthor() {
            guard !firstName.removeWhitespacesAndNewlines.isEmpty else { return }

            let newAuthor = SBAuthor(firstName: firstName, lastName: lastName,
                                     email: email,
                                     joinedDate: Date())
            withAnimation {
                showAuthor.toggle()
            }
            completion(newAuthor)
        }
    }
}

struct AuthorEditor_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView.AuthorEditor(isShown: .constant(true), author: nil) { _ in }
    }
}
