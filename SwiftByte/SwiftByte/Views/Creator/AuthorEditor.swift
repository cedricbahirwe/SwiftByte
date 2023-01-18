//
//  AuthorEditor.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 17/01/2023.
//

import SwiftUI

extension CreatorView {
    struct AuthorEditor: View {
//        init(author: Binding<SBAuthor?>,
//             completion: @escaping (SBAuthor) -> Void) {
//            self.firstName = author.wrappedValue?.firstName ?? ""
//            self.lastName = author.wrappedValue?.lastName ?? ""
//            self.email = author.wrappedValue?.email ?? ""
//            self.completion = completion
//        }
//
        @State var firstName: String
        @State var lastName: String
        @State var email: String
        
        var completion: (SBAuthor) -> Void
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Add Author")
                    .font(.title2.weight(.bold))
                    .frame(maxWidth: .infinity)
                
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
        
        private func saveAuthor() {
            guard !firstName.removeWhitespacesAndNewlines.isEmpty else { return }
            
            let newAuthor = SBAuthor(firstName: firstName, lastName: lastName,
                                     email: email,
                                     joinedDate: Date())
            completion(newAuthor)
        }
    }
}

//struct AuthorEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatorView.AuthorEditor(author: .constant(nil)) { _ in }
//    }
//}
