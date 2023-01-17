//
//  CreatorView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 21/12/2022.
//

import SwiftUI

struct CreatorView: View {
    @State private var articleVM = ArticlesViewModel()
    @State private var art = SBArticle.empty
    @State private var newKeyword = ""
    @State private var newLinkURL = ""
    @State private var newLinkName = ""
    @State private var intro = SBArticleContent(body: "")
    @State private var editedAuthor: SBAuthor?
    @State private var showAuthor = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                sectionOne


                keywordsView

                newContentView

                linksView

                Spacer(minLength: 1)
                Button("Submit", action: submit)

            }
            .padding(.horizontal)
            .background(
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .onTapGesture(perform: hideKeyboard)
            )
        }
        .tint(.blue)
        
    }

    private func submit() {
        guard !art.title.isEmpty else { return }
        guard !art.content.isEmpty else { return }

        art.author = editedAuthor
        art.intro = intro
        art.createdDate = Date()
        art.updateDate = nil

        articleVM.addNewArticle(art)
//        art = SBArticle.empty
    }

    private func addKeyword() {
        let newKeyword = newKeyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !newKeyword.isEmpty else { return }

        if !art.keywords.map(\.name).contains(newKeyword) {
            art.keywords.append(.init(newKeyword))
        }
        self.newKeyword = ""
    }

    private func removeKeyword(_ keyword: SBArticleKeyWord) {
        if let index = art.keywords.firstIndex(of: keyword) {
            art.keywords.remove(at: index)
        }
    }

    private func addNewLink() {
        guard let newURL = URL(string: newLinkURL) else { return }
        let newName = newLinkName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : newLinkName


        if !art.moreResources.contains(where: {
            $0.name == newName ||
            $0.url == newURL
        }) {
            let newLink = SBLink(name: newName, url: newURL)
            self.art.moreResources.append(newLink)
        }

        self.newLinkName = ""
        self.newLinkURL = ""
    }

    private func removeLink(_ link: SBLink) {
        if let index = art.moreResources.firstIndex(of: link) {
            art.moreResources.remove(at: index)
        }
    }

    private func addNewContent(_ content: SBArticleContent) {
        if !art.content.contains(where: { $0.body == content.body }) {
            art.content.append(content)
        }
    }
}

extension CreatorView {
    struct AuthorEditor: View {
        init(author: SBAuthor?, completion: @escaping (SBAuthor) -> Void) {
            self.firstName = author?.firstName ?? ""
            self.lastName = author?.lastName ?? ""
            self.email = author?.email ?? ""
            self.bio = author?.bio ?? ""
            self.completion = completion
        }

        @State private var firstName: String
        @State private var lastName: String
        @State private var email: String
        @State private var bio: String

        var completion: (SBAuthor) -> Void

        var body: some View {
            VStack(alignment: .leading) {
                TextField("First name", text: $firstName)
                    .applyField()

                TextField("Last name", text: $lastName)
                    .applyField()


                TextField("Email", text: $email)
                    .applyField()

                HStack {
                    TextField("Bio", text: $bio)
                        .applyField()
                    Button("Save", action: saveAuthor)
                }
            }
        }

        private func saveAuthor() {
            guard !firstName.cleaned.isEmpty else { return }
            let bioCleaned = bio.cleaned.isEmpty ? nil : bio.cleaned

            let newAuthor = SBAuthor(firstName: firstName, lastName: lastName,
                                     email: email, bio: bioCleaned,
                                     joinedDate: Date())
            completion(newAuthor)
        }
    }

    struct ContentEditor: View {
        @State private var content = SBArticleContent(body: "")
        @State private var fgColor = Color.clear
        @State private var bgColor = Color.clear
        private let styles = SBArticleContent.Style.allCases
        @State private var selectedStyle: SBArticleContent.Style?
        private let weights = SBArticleContent.Weight.allCases
        @State private var selectedWeight: SBArticleContent.Weight?
        private let designs = SBArticleContent.Design.allCases
        @State private var selectedDesign: SBArticleContent.Design?
        @State private var radius: Double?
        @State private var isShown = false

        var completion: (SBArticleContent) -> Void

        var body: some View {
            VStack(alignment: .leading) {
                if isShown {
                    VStack(alignment: .leading) {
                        Text("Section Body").bold()

                        TextField("Article Content", text: $content.body,
                                  prompt: Text("Add Body"), axis: .vertical)
                        .applyField()
                    }

                    HStack {
                        Picker("Please choose a text style",
                               selection: Binding(get: {
                            selectedStyle ?? .body
                        }, set: { selectedStyle = $0 })) {
                            ForEach(styles, id: \.self) {
                                Text($0.rawValue.capitalized)
                            }
                        }

                        Picker("Please choose a text weight",
                               selection: Binding(get: {
                            selectedWeight ?? .regular
                        }, set: { selectedWeight = $0 })) {
                            ForEach(weights, id: \.self) {
                                Text($0.rawValue.capitalized)
                            }
                        }

                        Picker("Please choose a text design",
                               selection: Binding(get: {
                            selectedDesign ?? .default
                        }, set: { selectedDesign = $0 })) {
                            ForEach(designs, id: \.self) {
                                Text($0.rawValue.capitalized)
                            }
                        }
                    }
                    HStack {
                        ColorPicker("Set the text color", selection: $fgColor)
                            .foregroundColor(fgColor == .clear ? .primary : fgColor)

                        if fgColor != .clear {
                            Button("Remove text color", role: .destructive) {
                                fgColor = .clear
                            }
                        }
                    }

                    HStack {
                        ColorPicker("Set the background color", selection: $bgColor)
                            .background(bgColor == .clear ? .white : bgColor)
                        if bgColor != .clear {
                            Button("Remove background color", role: .destructive) {
                                bgColor = .clear
                            }
                        }
                    }

                    HStack {
                        Text("Content Border Radius")
                        TextField("Enter your border radius",
                                  value: Binding(
                                    get: {
                                        radius ?? 0
                                    },
                                    set: { radius = $0 }),
                                  format: .number)
                        .applyField()
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 25, alignment: .leading)
            .overlay(alignment: .topTrailing) {
                HStack {
                    if isShown {
                        Button("Save") {
                            saveArticle()
                        }


                    } else {
                        Text(content.body.isEmpty ? "New Section" : content.body).bold()
                            .lineLimit(1)
                        Spacer()
                    }
                    Image(systemName: "chevron.down")
                        .padding(8)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation {
                                isShown.toggle()
                            }
                        }
                }
            }
        }

        func saveArticle() {
            guard !content.body.cleaned.isEmpty else { return }

            let fgColorString = fgColor == .clear ? nil : fgColor.toHex()
            let bgColorString = bgColor == .clear ? nil : bgColor.toHex()

            content.color = fgColorString
            content.background = bgColorString
            content.style = selectedStyle ?? .body
            content.weight = selectedWeight
            content.design = selectedDesign
            content.radius = radius

            completion(content)

            content = SBArticleContent(body: "")
            withAnimation {
                isShown = false
            }
        }
    }
}

private extension CreatorView {
    var sectionOne: some View {
        Group {
            VStack(alignment: .leading) {
                Text("Article Title").bold()

                TextField("Article Title",
                          text: $art.title,
                          prompt: Text("Add Article title"),
                          axis: .vertical)
                           .applyField()
            }

            VStack(alignment: .leading) {
                HStack {
                    Text("Author").bold()
                    Button(showAuthor ? "Hide" : "Show") {
                        withAnimation {
                            showAuthor.toggle()
                        }
                    }
                    Spacer()
                }

                if showAuthor {
                    AuthorEditor(author: editedAuthor) { newAuthor in
                        self.editedAuthor = newAuthor
                    }
                }
            }

            VStack(alignment: .leading) {
                Text("Intro Content").bold()

                ContentEditor { bodyContent in
                    intro = bodyContent
                }
            }
        }
    }
    var keywordsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Keywords \(art.keywords.count)").bold()
            HStack {
                TextField("Add New Keyword", text: $newKeyword)
                    .applyField()

                Button("Add", action: addKeyword)
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(art.keywords, id: \.self) { keyword in
                        Text(keyword.name)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.regularMaterial)
                            .clipShape(Capsule())
                            .contentShape(Capsule())
                            .onTapGesture(count: 2) {
                                removeKeyword(keyword)
                            }
                    }
                }
            }
        }
    }

    var newContentView: some View {
        VStack(alignment: .leading) {
            Text("Article Content \(art.content.count)").bold()

            ContentEditor(completion: addNewContent)

        }
    }

    var linksView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Links \(art.moreResources.count)").bold()

                TextField("Add Link Name", text: $newLinkName)
                    .applyField()
            }

            HStack {
                TextField("Add Link URL", text: $newLinkURL)
                    .applyField()

                Button("Add Link", action: addNewLink)
            }

            ScrollView(.horizontal) {
                HStack {
                    ForEach(art.moreResources, id: \.self) { source in
                        VStack(alignment: .leading) {
                            Text(source.description)
                            Text(source.url.description)
                                .foregroundColor(.blue)
                        }
                        .padding(10)
                        .frame(maxWidth: 250)
                        .background(.regularMaterial)
                        .cornerRadius(10)
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture(count: 2) {
                            removeLink(source)
                        }
                    }
                }
            }
        }
    }

}

struct CreatorView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView()
    }
}

extension String {
    var cleaned: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension View {
    func applyField() -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.red)
                .frame(width: 2)
            self
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(10)
        .background(Color.lightShadow)
        .cornerRadius(10)

    }
}
