//
//  ProfileView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.isPreview) private var isPreview

    private var user: SBUser? {
        #if DEBUG
        isPreview ? SBUser.sample : authViewModel.getCurrentUser()
        #else
        authViewModel.getCurrentUser()
        #endif
    }
    @Environment(\.dismiss) private var dismiss
    @State private var showingConfirmation = false
    

    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    
    private let colors = [Color(#colorLiteral(red: 0.9843137255, green: 0.9176470588, blue: 0.6470588235, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.3333333333, blue: 0.6117647059, alpha: 1)), Color(#colorLiteral(red: 0.4156862745, green: 0.7098039216, blue: 0.9294117647, alpha: 1)), Color(#colorLiteral(red: 0.337254902, green: 0.1137254902, blue: 0.7490196078, alpha: 1)), Color(#colorLiteral(red: 0.337254902, green: 0.9215686275, blue: 0.8509803922, alpha: 1))]
    private let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var background: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true).speed(0.5), value: start)
            .onReceive(timer, perform: { _ in
                self.start = UnitPoint(x: 4, y: 0)
                self.end = UnitPoint(x: 0, y: 2)
                self.start = UnitPoint(x: -4, y: 20)
                self.start = UnitPoint(x: 4, y: 0)
            })
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let user {
                VStack(spacing: 4) {
                    ZStack {
                        background
                            .blur(radius: 10)
                            .mask(Circle())
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                        .shadow(radius: 10)
                        AsyncImage(url: URL(string: user.profilePicture ?? "")) { image in
                            image.resizable()
                                .scaledToFit()
                                
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundStyle(.regularMaterial)
                        }
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                    }
                    .padding()

                    Text(user.getFullName())
                        .font(.title.weight(.medium))
                    
                    Group {
                        Text(user.email)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        HStack(spacing: 0) {
                            Text("Joined: ")
                            Text(user.joinDate, style: .date)
                                .italic()
                        }
                    }
                }
                .padding(.bottom)

                // TODO: HAVE BOOKMARKS HERE MAY BE

                LButton("Log out") {
                    authViewModel.signOut()
                    dismiss()
                }

                LButton("Delete Account", fg:.red, bg: .clear) {
                    showingConfirmation.toggle()
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
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthenticationViewModel())
    }
}
#endif

struct AnimatedBackground: View {
    @State private var gradientOffset: CGFloat = 0.0

    let gradientColors = [Color(red: 0.09, green: 0.23, blue: 0.44),
                          Color(red: 0.23, green: 0.56, blue: 0.78),
                          Color(red: 0.56, green: 0.87, blue: 0.95),
                          Color(red: 0.93, green: 0.98, blue: 1.0)]

    let gradientStartPoint = UnitPoint(x: 0, y: 0)
    let gradientEndPoint = UnitPoint(x: 1, y: 1)

    let animationDuration: Double = 5.0

    var body: some View {
        LinearGradient(gradient: Gradient(colors: gradientColors),
                       startPoint: gradientStartPoint,
                       endPoint: gradientEndPoint)
            .offset(x: gradientOffset)
            .animation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: true), value: gradientOffset)
            .onAppear {
                self.gradientOffset = -1.0
            }
    }
}
