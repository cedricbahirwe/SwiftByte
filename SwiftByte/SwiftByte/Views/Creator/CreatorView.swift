//
//  CreatorView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 21/12/2022.
//

import SwiftUI

struct CreatorView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var articleVM = ArticlesViewModel()
    @State private var art = SBArticle.empty
    @State private var newKeyword = ""
    @State private var newLinkURL = ""
    @State private var newLinkName = ""
    @State private var intro = SBArticleContent(body: "")
    @State private var editedAuthor: SBAuthor?
    @State private var showAuthor = true
    @State private var currentStep: SubmissionStep = .author
    enum SubmissionStep: Int, CaseIterable {
        case author, intro, keywords, section, links
        mutating func next() {
            self = .init(rawValue: rawValue+1) ?? Self.allCases.first!
        }
        mutating func previous() {
            self = .init(rawValue: rawValue-1) ?? Self.allCases.last!
        }

    }
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    switch currentStep {
                    case .author:
                        AuthorEditor(isShown: $showAuthor, author: editedAuthor) {
                            self.editedAuthor = $0
                            self.currentStep.next()
                        }
                    case .intro:
                        TitleAndIntro(title: $art.title,
                                      intro: $intro)
                    case .keywords:
                        keywordsView
                    case .section:
                        newContentView
                    case .links:
                        linksView
                    }

                }

            }

            bottomBarView
        }
        .padding(.horizontal)
        .background(
            Color(.systemBackground)
                .ignoresSafeArea()
                .onTapGesture(perform: hideKeyboard)
        )
        .tint(.blue)
        .onAppear() {
            //            editedAuthor = authViewModel.getCurrentUser()?.toAuthor()
        }
        
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

    

    var bottomBarView: some View {
        HStack {
            LButton("<") {
                withAnimation {
                    currentStep.previous()
                }
            }.frame(width: 50)
            LButton("Submit", action: submit)
            LButton(">") {
                withAnimation {
                    currentStep.next()
                }
            }.frame(width: 50)
        }
    }

}

struct CreatorView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView()
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
