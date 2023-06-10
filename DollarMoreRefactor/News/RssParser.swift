//
//  RssParser.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/28.
//

import Foundation

final class RssParser: NSObject, XMLParserDelegate {
    private var newsItems: [NewsItem] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentdescription = ""
    private var currentPubDate = ""

    public func getNewsItems() -> [NewsItem] {
        return newsItems
    }

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
            currentdescription = ""
            currentPubDate = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!data.isEmpty) {
            switch currentElement {
            case "title":
                currentTitle += data
                    .replacingOccurrences(of: "&", with: "")
                    .replacingOccurrences(of: "quot;", with: "\"" )
                    .replacingOccurrences(of: "lt;", with: "")
                    .replacingOccurrences(of: "표", with: "")
                    .replacingOccurrences(of: "gt;", with: "<표>")
                    .replacingOccurrences(of: "amp;", with: "&")
            case "link": currentLink += data
            case "description": currentdescription += data
            case "pubDate": currentPubDate += data
            default: break
            }
        }
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        if elementName == "item" {
            newsItems
                .append(
                    NewsItem(
                        title: currentTitle,
                        description: currentdescription,
                        pubDate: currentPubDate,
                        link: currentLink
                    )
                )
        }
    }
}
