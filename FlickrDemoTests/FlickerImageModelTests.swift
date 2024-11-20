//
//  FlickerImageModelTests.swift
//  FlickrDemoTests
//
//  Created by Malek Saadeh on 11/19/24.
//

import XCTest
import Combine
@testable import FlickrDemo

class FlickerImageModelTests: XCTestCase {

    var networkService: FlickrNetworkService!
        var cancellables: Set<AnyCancellable>!
        
        override func setUp() {
            super.setUp()
            networkService = FlickrNetworkService()
            cancellables = []
        }
        
        override func tearDown() {
            networkService = nil
            cancellables = nil
            super.tearDown()
        }
    
    
    func testFlickrImageModel() {
           // Sample image for testing
           let sampleMedia = FlickrImage.MediaLink(m: "https://example.com/image_m.jpg")
           let sampleImage = FlickrImage(
               title: "Test Image",
               link: "https://example.com",
               media: sampleMedia,
               description: "A test description",
               author: "Test Author",
               published: "2023-11-19T12:00:00Z"
           )
           
           // Test properties
           XCTAssertEqual(sampleImage.title, "Test Image")
           XCTAssertNotNil(sampleImage.thumbnailURL)
           XCTAssertNotNil(sampleImage.largeImageURL)
       }


}
