//
//  RootViewModelTests.swift
//  RainstormTests
//
//  Created by Bart Jacobs on 13/12/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import XCTest
import Mockingjay
@testable import Rainstorm

class RootViewModelTests: XCTestCase {

    // MARK: - Properties
    
    var viewModel: RootViewModel!
    
    // MARK: -
    
    var locationService: MockLocationService!

    // MARK: - Set Up & Tear Down
    
    override func setUp() {
        super.setUp()
        
        // Initialize Mock Location Service
        locationService = MockLocationService()
        
        // Initialize Root View Model
        viewModel = RootViewModel(networkService: NetworkManager(), locationService: locationService)
    }

    override func tearDown() {
        super.tearDown()
        
        // Reset User Defaults
        UserDefaults.standard.removeObject(forKey: "didFetchWeatherData")
    }
    
    // MARK: - Tests for Refresh
    
    func testRefresh_Success() {
//        // Load Stub
//        let data = loadStub(name: "darksky", extension: "json")
//
//        // Define Stub
//        stub(everything, jsonData(data))

        // Define Expectation
        let expectation = XCTestExpectation(description: "Fetch Weather Data")

        // Install Handler
        viewModel.didFetchWeatherData = { (result) in
            if case .success(let weatherData) = result {
                XCTAssertEqual(weatherData.latitude, 37.8267)
                XCTAssertEqual(weatherData.longitude, -122.4233)

                // Fulfill Expectation
                expectation.fulfill()
            }
        }
        
        // Invoke Method Under Test
        viewModel.refresh()
        
        // Wait for Expectation to Be Fulfilled
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRefresh_FailedToFetchLocation() {
        // Configure Location Service
        locationService.location = nil
        
        // Define Expectation
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        // Install Handler
        viewModel.didFetchWeatherData = { (result) in
            if case .failure(let error) = result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.notAuthorizedToRequestLocation)
                
                // Fulfill Expectation
                expectation.fulfill()
            }
        }
        
        // Invoke Method Under Test
        viewModel.refresh()
        
        // Wait for Expectation to Be Fulfilled
        wait(for: [expectation], timeout: 2.0)
    }
 
    func testRefresh_FailedToFetchWeatherData_RequestFailed() {
////         Create Error
//        let error = NSError(domain: "com.cocoacasts.network", code: 1, userInfo: nil)
//        
////         Define Stub
//        stub(everything, failure(error))

        // Define Expectation
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        // Install Handler
        viewModel.didFetchWeatherData = { (result) in
            if case .failure(let error) = result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.noWeatherDataAvailable)
                
                // Fulfill Expectation
                expectation.fulfill()
            }
        }
        
        // Invoke Method Under Test
        viewModel.refresh()
        
        // Wait for Expectation to Be Fulfilled
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRefresh_FailedToFetchWeatherData_InvalidResponse() {
//        // Load Stub
        let body = ["some":"data"]

        // Define Stub
        stub(everything, json(body))
        
        // Define Expectation
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        // Install Handler
        viewModel.didFetchWeatherData = { (result) in
            if case .failure(let error) = result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.noWeatherDataAvailable)
                
                // Fulfill Expectation
                expectation.fulfill()
            }
        }
        
        // Invoke Method Under Test
        viewModel.refresh()
        
        // Wait for Expectation to Be Fulfilled
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRefresh_FailedToFetchWeatherData_NoErrorNoResponse() {
//         Define Stub
//        stub(everything) { (request) -> (Response) in
//            // Create HTTP URL Response
//            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
//
//            return .success(response, .noContent)
//        }
        
        // Define Expectation
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        // Install Handler
        viewModel.didFetchWeatherData = { (result) in
            if case .failure(let error) = result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.noWeatherDataAvailable)
                
                // Fulfill Expectation
                expectation.fulfill()
            }
        }
        
        // Invoke Method Under Test
        viewModel.refresh()
        
        // Wait for Expectation to Be Fulfilled
        wait(for: [expectation], timeout: 2.0)
    }
 
    // MARK: - Tests for Refreshing Weather Data
    
    func testApplicationWillEnterForeground_NoTimestamp() {
        // Reset User Defaults
        UserDefaults.standard.removeObject(forKey: "didFetchWeatherData")
        
        // Define Expectation
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        // Install Handler
        viewModel.didFetchWeatherData = { (result) in
            // Fulfill Expectation
            expectation.fulfill()
        }
        
        // Post Notification
        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        // Wait for Expectation to Be Fulfilled
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testApplicationWillEnterForeground_ShouldRefresh() {
        // Reset User Defaults
        UserDefaults.standard.set(Date().addingTimeInterval(-3600.0), forKey: "didFetchWeatherData")

        // Define Expectation
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        // Install Handler
        viewModel.didFetchWeatherData = { (result) in
            // Fulfill Expectation
            expectation.fulfill()
        }
        
        // Post Notification
        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        // Wait for Expectation to Be Fulfilled
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testApplicationWillEnterForeground_ShouldNotRefresh() {
        // Reset User Defaults
        UserDefaults.standard.set(Date(), forKey: "didFetchWeatherData")

        // Define Expectation
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        // Configure Expectation
        expectation.isInverted = true

        // Install Handler
        viewModel.didFetchWeatherData = { (result) in
            // Fulfill Expectation
            expectation.fulfill()
        }
        
        // Post Notification
        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        // Wait for Expectation to Be Fulfilled
        wait(for: [expectation], timeout: 2.0)
    }
    
}
