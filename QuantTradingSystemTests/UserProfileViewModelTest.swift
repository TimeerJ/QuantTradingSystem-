//
//  UserProfileViewModelTest.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/31/24.
//

import XCTest
import Combine
import CoreData
@testable import QuantTradingSystem

// 模拟 CoreDataService
class MockCoreDataService: CoreDataService {
    var users: [UserEntity] = []
    
    override func fetchEntities<T>(_ type: T.Type, predicate: NSPredicate? = nil) -> [T] where T : NSManagedObject {
        return users as? [T] ?? []
    }
    
    override func saveEntity<T>(_ type: T.Type, updateBlock: (T) -> Void) -> Bool where T : NSManagedObject {
        if let user = users.first {
            updateBlock(user as! T)
        } else {
            let context = persistentContainer.viewContext
            let user = UserEntity(context: context)
            updateBlock(user as! T)
            users.append(user)
        }
        return true
    }
}

class UserProfileViewModelTests: XCTestCase {
    var viewModel: UserProfileViewModel!
    var cancellables: Set<AnyCancellable>!
    var mockCoreDataService: MockCoreDataService!
    
    override func setUp() {
        super.setUp()
        mockCoreDataService = MockCoreDataService()
        viewModel = UserProfileViewModel(coreDataService: mockCoreDataService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockCoreDataService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadProfileSuccess() {
        // 模拟 CoreData 中已有用户数据
        let user = UserEntity(context: mockCoreDataService.persistentContainer.viewContext)
        user.username = "testuser"
        user.email = "test@example.com"
        mockCoreDataService.users = [user]
        
        let expectation = XCTestExpectation(description: "Load profile")
        
        viewModel.loadProfile()
        
        viewModel.$username
            .dropFirst()
            .sink { username in
                XCTAssertEqual(username, "testuser")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadProfileFailure() {
        // 模拟 CoreData 中没有用户数据
        mockCoreDataService.users = []
        
        let expectation = XCTestExpectation(description: "Load profile failure")
        
        viewModel.loadProfile()
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "User not found")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateUserProfile() {
        // 模拟 CoreData 中已有用户数据
        let user = UserEntity(context: mockCoreDataService.persistentContainer.viewContext)
        user.username = "olduser"
        user.email = "old@example.com"
        mockCoreDataService.users = [user]
        
        viewModel.updateUserProfile(username: "newuser", email: "new@example.com")
        
        XCTAssertEqual(mockCoreDataService.users.first?.username, "newuser")
        XCTAssertEqual(mockCoreDataService.users.first?.email, "new@example.com")
    }
}
