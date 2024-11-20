//
//  StringExtensionTests.swift
//  FlickrDemoTests
//
//  Created by Malek Saadeh on 11/19/24.
//

import XCTest
@testable import FlickrDemo

final class StringExtensionTests: XCTestCase {

    func testHtmlStripping() {
        let htmlString = " <p><a href=\"https://www.flickr.com/people/fotobyst/\">Samuele Trevisanello</a> posted a photo:</p> <p><a href=\"https://www.flickr.com/photos/fotobyst/54139951651/\" title=\"Daf XG+ W.Pape &amp; ZN.\"><img src=\"https://live.staticflickr.com/65535/54139951651_44dd2244bc_m.jpg\" width=\"240\" height=\"160\" alt=\"Daf XG+ W.Pape &amp; ZN.\" /></a></p> <p><a href=\"https://www.instagram.com/truckfotobyst/\" rel=\"noreferrer nofollow\">Instagram Trucks Profile </a></p> "
        let expectedString = "Samuele Trevisanello posted a photo:\n￼\nInstagram Trucks Profile \n"
        let strippedString = htmlString.htmlStripped
        XCTAssertEqual(strippedString, expectedString)
    }
}
