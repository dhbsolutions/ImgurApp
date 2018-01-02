//
//  ImgurAppTests.swift
//  ImgurAppTests
//
//  Created by Dave Butler on 12/29/17.
//  Copyright © 2017 Dave Butler. All rights reserved.
//

import XCTest
@testable import ImgurApp

class ImgurAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImgurWebsite() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // TEST THAT THE IMGUR WEBSITE IS UP AND THAT WE CAN SUCCESSFULLY HIT THE MAIN PAGE
        let url = URL(string: "http://www.imgur.com/")!
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let response = response as? HTTPURLResponse,
                let responseURL = response.url,
                let mimeType = response.mimeType
            {
                XCTAssertEqual(responseURL.absoluteString, url.absoluteString, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(response.statusCode, 200, "HTTP response status code should be 200")
                XCTAssertEqual(mimeType, "text/html", "HTTP response content type should be text/html")
            } else {
                XCTFail("Responses from http://www.imgur.com/ not as expected, check that site is available")
            }
            
        }
        
        task.resume()

        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
