//
//  ProfileView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @AppStorage(AppLocalKeys.allowNotifications.rawValue)
    private var isNotificationsEnabled: Bool = false
    @Environment(\.isPreview) private var isPreview

    private var user: SBUser? {
#if DEBUG
        isPreview ? SBUser.sample : authViewModel.getCurrentUser()
#else
        authViewModel.getCurrentUser()
#endif
    }
    @Environment(\.dismiss) private var dismiss
    @State private var showingAccountDeletionAlert = false

    var body: some View {
        NavigationStack {
            Form {
                if let user {
                    HStack(spacing: 16) {
                        ZStack {
                            AnimatedBackgroundView()
                                .blur(radius: 10)
                                .frame(width: 70, height: 70)
                                .clipShape(.circle)
                                .shadow(radius: 10)

                            AsyncImage(url: URL(string: user.profilePicture ?? "")) { image in
                                image.resizable()
                                    .scaledToFit()

                            } placeholder: {
                                EmptyView()
                            }
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .clipShape(.circle)
                        }

                        VStack(alignment: .leading, spacing: 0) {
                            Text(user.getFullName())
                                .font(.title2.weight(.bold))

                            Text(user.email)
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
//                    .listRowInsets(EdgeInsets())

                    // TODO: HAVE BOOKMARKS HERE
                    // TODO: HAVE Profile Status HERE

                    Section {
                        if isNotificationsEnabled {
                            Toggle("Notifications", isOn: .constant(isNotificationsEnabled))
                                .disabled(true)
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notifications are currently disabled.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Button {
                                    Task {
                                        await openAppNotificationsSettings()
                                    }
                                } label: {
                                    Label("Enable Notifications in Settings", systemImage: "gear")
                                }
                            }
                        }
                    } header: {
                        Text("Notifications")
                    } footer: {
                        if !isNotificationsEnabled {
                            Text("Turn on notifications to receive updates and alerts. You can enable them from the Settings app.")
                        }
                    }

                    Section {

                        Button {
                            authViewModel.signOut()
                            dismiss()
                        } label: {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(.red)
                        }

                        Button(role: .destructive) {
                            showingAccountDeletionAlert.toggle()
                        } label: {
                            Label("Delete Account", systemImage: "trash")
                                .foregroundStyle(.red)
                        }

                    }

                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                if let user {
                    LabeledContent("Member since: ",
                                   value: user.joinDate.formatted(date: .long, time: .omitted))
                    .padding()
                    .background(.ultraThinMaterial)
                }
            }
            .confirmationDialog(
                "Do you really want to delete your account?",
                isPresented: $showingAccountDeletionAlert,
                titleVisibility: .visible) {
                    Button("Delete Account", role: .destructive, action: deleteAccount)
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("This action cannot be undone.")
                }
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

    private func openAppNotificationsSettings() async {
        if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
            await UIApplication.shared.open(url)
        }
    }

    struct AnimatedBackgroundView: View {
        @State var start = UnitPoint(x: 0, y: -2)
        @State var end = UnitPoint(x: 4, y: 0)

        private let colors = [Color(#colorLiteral(red: 0.9843137255, green: 0.9176470588, blue: 0.6470588235, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.3333333333, blue: 0.6117647059, alpha: 1)), Color(#colorLiteral(red: 0.4156862745, green: 0.7098039216, blue: 0.9294117647, alpha: 1)), Color(#colorLiteral(red: 0.337254902, green: 0.1137254902, blue: 0.7490196078, alpha: 1)), Color(#colorLiteral(red: 0.337254902, green: 0.9215686275, blue: 0.8509803922, alpha: 1))]
        private let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()

        var body: some View {
            LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
                .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true).speed(0.5), value: start)
                .onReceive(timer, perform: { _ in
                    self.start = UnitPoint(x: 4, y: 0)
                    self.end = UnitPoint(x: 0, y: 2)
                    self.start = UnitPoint(x: -4, y: 20)
                    self.start = UnitPoint(x: 4, y: 0)
                })
        }
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthenticationViewModel())
            .previewLayout(.fixed(width: 410, height: 620))
            .preferredColorScheme(.dark)
    }
}
#endif

