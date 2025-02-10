//
//  MockData.swift
//  FlickrDemoTests
//
//  Created by uuser on 2/7/25.
//

import Foundation

import Foundation

let mockData: Data  = """
{
        "title": "Images tagged apples",
        "link": "https://www.flickr.com/photos/tags/apples/",
        "description": "",
        "modified": "2025-02-07T07:01:02Z",
        "generator": "https://www.flickr.com",
        "items": [
       {
            "title": "First ex",
            "link": "https://www.malekmockdemo.com/id/0000",
            "media": {"m":"https://www.malekmockdemo.com/id/0000"},
            "date_taken": "2025-02-07T07:01:02Z",
            "description": "Here is a nice big adam's apple",
            "published": "2025-02-07T07:01:02Z",
            "author": "Adam Apple, apple@gmail.com",
            "author_id": "0000",
            "tags": "adam tag"
       },

       {
            "title": "Second example",
            "link": "https://www.malekmockdemo.com/id/0001",
            "media": {"m":"https://www.malekmockdemo.com/id/0001"},
            "date_taken": "2025-02-07T07:01:02Z",
            "description": "Another desc",
            "published": "2025-02-07T07:01:02Z",
            "author": "Billy Bob, BobBilly@gmail.com",
            "author_id": "0001",
            "tags": "adam tag"
       },

       {
            "title": "Yapping Title",
            "link": "https://www.malekmockdemo.com/id/2101192",
            "media": {"m":"https://www.malekmockdemo.com/id/2101192"},
            "date_taken": "2025-02-07T07:01:02Z",
            "description": "YapYap",
            "published": "2025-02-07T07:01:02Z",
            "author": "Darrel Dockett, DDocks@gmail.com",
            "author_id": "2101192",
            "tags": "adam tag"
       },

       {
            "title": "Last data for now",
            "link": "https://www.malekmockdemo.com/id/37423572",
            "media": {"m":"https://www.malekmockdemo.com/id/37423572"},
            "date_taken": "2025-02-07T07:01:02Z",
            "description": "This is a photo of a giant conch shell apple and no pubclished date",
            "published": "",
            "author": "Carl Conchshell, Carl@gmail.com",
            "author_id": "37423572",
            "tags": "adam tag"
       }]
}

""".data(using: .utf8)!

///test for empty
let emptyData: Data = """
{
        "title": "Images tagged apples",
        "link": "https://www.flickr.com/photos/tags/apples/",
        "description": "",
        "modified": "2025-02-07T07:01:02Z",
        "generator": "https://www.flickr.com",
        "items": []
}
""".data(using: .utf8)!


///test for bad Data
let badData: Data =
"""
{
    arbitrary bad information
    2 lines
    3 lines?
}
""".data(using: .utf8)!
