//
//  SBLink.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 21/12/2022.
//

import Foundation

struct SBLink: Hashable, Codifiable {
    var id: String { url.absoluteString }

    var name: String?
    var url: URL

    var description: String {
        name ?? url.description
    }

    init(name: String? = nil, url: URL) {
        self.name = name
        self.url = url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.url = try container.decode(URL.self, forKey: .url)
    }
}
