//
//  SearchViewModelTests.swift
//  FlickrDemoTests
//
//  Created by uuser on 2/7/25.
//

import XCTest
import Foundation
import Combine
@testable import FlickrDemo

class SearchViewModelTests: XCTestCase {
    
    private var cancellabes = Set<AnyCancellable>()
    private var vM: SearchViewModel!
    
    override func setUp() async throws {
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: sessionConfiguration)
        
        let flickrService = FlickrService(session: session)
        vM = await SearchViewModel(flickrService: flickrService)
    }
    
    override func tearDown() async throws {
        
    }
    
    func testFetchItems_Success() async throws {
        MockURLProtocol.setSuccessHandler()

        let mockEx = try await vM.flickrService.fetchData(for: "apples")
                
        XCTAssert(mockEx.count == 4)

        let mockImage0 = mockEx[0]
        let mockImage1 = mockEx[1]
        let mockImage2 = mockEx[2]
        let mockImage3 = mockEx[3]
       
        XCTAssert(mockImage0.title == "First ex")
        XCTAssert(mockImage0.link == "https://www.malekmockdemo.com/id/0000")
        XCTAssert(mockImage0.media.m == "https://www.malekmockdemo.com/id/0000")
        XCTAssert(mockImage0.dateTaken == "2025-02-07T07:01:02Z")
        XCTAssert(mockImage0.description == "Here is a nice big adam's apple")
        XCTAssert(mockImage0.published == "2025-02-07T07:01:02Z")
        XCTAssert(mockImage0.author == "Adam Apple, apple@gmail.com")
        XCTAssert(mockImage0.tags == "adam tag")
        
        XCTAssert(mockImage1.title == "Second example")
        XCTAssert(mockImage1.link == "https://www.malekmockdemo.com/id/0001")
        XCTAssert(mockImage1.media.m == "https://www.malekmockdemo.com/id/0001")
        XCTAssert(mockImage1.dateTaken == "2025-02-07T07:01:02Z")
        XCTAssert(mockImage1.description == "Another desc")
        XCTAssert(mockImage1.published == "2025-02-07T07:01:02Z")
        XCTAssert(mockImage1.author == "Billy Bob, BobBilly@gmail.com")
        XCTAssert(mockImage1.tags == "adam tag")
        
        XCTAssert(mockImage2.title == "Yapping Title")
        XCTAssert(mockImage2.link == "https://www.malekmockdemo.com/id/2101192")
        XCTAssert(mockImage2.media.m == "https://www.malekmockdemo.com/id/2101192")
        XCTAssert(mockImage2.dateTaken == "2025-02-07T07:01:02Z")
        XCTAssert(mockImage2.description == "YapYap")
        XCTAssert(mockImage2.published == "2025-02-07T07:01:02Z")
        XCTAssert(mockImage2.author == "Darrel Dockett, DDocks@gmail.com")
        XCTAssert(mockImage2.tags == "adam tag")
        
        XCTAssert(mockImage3.title == "Last data for now")
        XCTAssert(mockImage3.link == "https://www.malekmockdemo.com/id/37423572")
        XCTAssert(mockImage3.media.m == "https://www.malekmockdemo.com/id/37423572")
        XCTAssert(mockImage3.dateTaken == "2025-02-07T07:01:02Z")
        XCTAssert(mockImage3.description == "This is a photo of a giant conch shell apple and no pubclished date")
        XCTAssert(mockImage3.published == "")
        XCTAssert(mockImage3.author == "Carl Conchshell, Carl@gmail.com")
        XCTAssert(mockImage3.tags == "adam tag")
    }
    
    func testFetchMock_EmptyData() async throws {
        
        MockURLProtocol.setEmptyDataHandler()
        
        let items = try await vM.flickrService.fetchData(for: "apples")

        XCTAssert(items.isEmpty)
    }
    
    func testFetchMock_BadData() async throws {
        MockURLProtocol.setBadDataHandler()
        
        let throwsErrorExpectation = XCTestExpectation(description: "Fetching malformed data should throw error")
        
        do {
            let _ = try await vM.flickrService.fetchData(for: "apples")
        }
        catch {
            throwsErrorExpectation.fulfill()
        }

        await fulfillment(of: [throwsErrorExpectation], timeout: 1)
    }
}
