//
//  ContentEditor.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 17/01/2023.
//

import SwiftUI

extension CreatorView {
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
        @State private var isShown = true
        @State private var isShowStyling = true
        
        var completion: (SBArticleContent) -> Void
        
        var body: some View {
            VStack(alignment: .leading) {
                if isShown {
                    VStack(alignment: .leading) {
                        Text("Body").bold()

                        HStack(spacing: 0) {
                            Picker("Please choose a text style",
                                   selection: Binding(get: {
                                selectedStyle ?? .body
                            }, set: { selectedStyle = $0 })) {
                                ForEach(styles, id: \.self) {
                                    Text($0.rawValue.capitalized)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            Divider()
                            Picker("Please choose a text weight",
                                   selection: Binding(get: {
                                selectedWeight ?? .regular
                            }, set: { selectedWeight = $0 })) {
                                ForEach(weights, id: \.self) {
                                    Text($0.rawValue.capitalized)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            Divider()
                            Picker("Please choose a text design",
                                   selection: Binding(get: {
                                selectedDesign ?? .default
                            }, set: { selectedDesign = $0 })) {
                                ForEach(designs, id: \.self) {
                                    Text($0.rawValue.capitalized)
                                }
                            }
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(maxWidth: .infinity)

                            Divider()
                            Button {
                                withAnimation {
                                    isShowStyling.toggle()
                                }
                            } label: {
                                HStack(spacing: 1) {
                                    Text("Style:")
                                    Image(systemName: "chevron.\(isShowStyling ? "down" : "up").circle.fill")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                .frame(maxWidth: 70, maxHeight: .infinity)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .tint(.blue)

                        Divider()

                        TextField("Article Content", text: $content.body,
                                  prompt: Text("Add Body"), axis: .vertical)
                        .frame(minHeight: 90, alignment: .topLeading)

                        if isShowStyling {
                            Divider()
                            HStack(spacing: 0) {
                                HStack {
                                    Text("FG:")
                                    ColorPicker("Set color:", selection: $fgColor)
                                        .labelsHidden()
                                        .foregroundColor(fgColor == .clear ? .primary : fgColor)

                                    if fgColor != .clear {
                                        Button("Remove color", role: .destructive) {
                                            fgColor = .clear
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)

                                HStack {
                                    Text("BG:")
                                    ColorPicker("Set background:", selection: $bgColor)
                                        .labelsHidden()
                                        .background(bgColor == .clear ? .white : bgColor)
                                    if bgColor != .clear {
                                        Button("Remove background", role: .destructive) {
                                            bgColor = .clear
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)


                                HStack {
                                    Text("\(Image(systemName: "r.joystick.tilt.right"))")
                                    TextField("Enter your border radius",
                                              value: Binding(
                                                get: {
                                                    radius ?? 0
                                                },
                                                set: { radius = $0 }),
                                              format: .number)
                                    .padding(8)
                                    .background(.white)
                                    .cornerRadius(10)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }


                }
            }
            .frame(maxWidth: .infinity, minHeight: 25, alignment: .leading)
            .overlay(alignment: .topTrailing) {
                HStack {
                    if isShown {
                        Button("Save", action: saveArticle)
                            .tint(.blue)
                        
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
            .applyField()
        }
        
        func saveArticle() {
            guard !content.body.removeWhitespacesAndNewlines.isEmpty else { return }
            
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

struct ContentEditor_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView.ContentEditor() { _ in
            
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
