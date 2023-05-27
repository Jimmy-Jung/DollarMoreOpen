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
    var dateFormatter = DateFormatter()

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
            case "link": currentLink += data
            case "description": currentdescription += data
            case "pubDate":
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let newsDate = dateFormatter.date(from: data)!
                let currentDate = Date()
                let components = Calendar
                    .current
                    .dateComponents(
                        [.hour],
                        from: newsDate,
                        to: currentDate
                    )
                if components.hour! > 23 {
                    let components = Calendar
                        .current
                        .dateComponents(
                            [.day],
                            from: newsDate,
                            to: currentDate
                        )
                    currentPubDate += "\(components.day!)일 전"
                    
                } else {
                    if components.hour! < 1 {
                        let components = Calendar
                            .current
                            .dateComponents(
                                [.hour],
                                from: newsDate,
                                to: currentDate
                            )
                        currentPubDate += "\(components.minute!)분 전"
                    }
                    currentPubDate += "\(components.hour!)시간 전"
                }
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
