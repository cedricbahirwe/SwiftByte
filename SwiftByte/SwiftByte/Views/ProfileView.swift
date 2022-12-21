//
//  ProfileView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    private var user: SBUser? { authViewModel.getCurrentUser() }
    @Environment(\.dismiss) private var dismiss
    @State private var showingConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let user {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(user.getFullName())
                            .font(.headline)

                        Group {
                            Text(user.email)
                                .foregroundColor(.secondary)
                            if let joinedDate = user.joinDate {
                                HStack(spacing: 0) {
                                    Text("Joined: ")
                                    Text(joinedDate, style: .date)
                                }
                            }
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom)

                // TODO: HAVE BOOKMARKS HERE MAY BE

                Button {
                    authViewModel.signOut()
                    dismiss()
                } label: {
                    Text("Log out")
                        .font(.body.weight(.medium))
                        .foregroundColor(.offBackground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }


                Button {
                    showingConfirmation.toggle()
                } label: {
                    Text("Delete Account")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 20)
            }
            Spacer()
        }
        .padding()

        .confirmationDialog(
            "Do you really want to delete your account?",
            isPresented: $showingConfirmation,
            titleVisibility: .visible) {
                Button("Delete Account", role: .destructive, action: deleteAccount)
                Button("Cancel", role: .cancel) { }
            } message: {
            Text("This action cannot be undone.")
        }
    }

    private func deleteAccount() {
        Task {
            await authViewModel.deleteAccount()
            DispatchQueue.main.async {
                dismiss()
            }
        }
    }
}

#if DEBUG
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(user: .sample)
//    }
//}
#endif
