import XCTest
@testable import swiftMVVM

enum AppViewState {
    case login
    case loggedArea
}

struct User {
    
}

protocol SessionService {
    var user: User? {get}
}

final class AppViewModel {
    
    @Published private(set) var state: AppViewState
    
    init(sessionService: SessionService){
        self.state = sessionService.user == nil ? .login : .loggedArea
    }
}



final class AppViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    func test_WhenUserIsLoggedIn_ShowsLogedArea(){
     
        let sut = makeSUT(isLoggedIn: true)
        
        XCTAssert(sut.state == .loggedArea)
    
    }
    
    func test_WhenUserIsNotLoggedIn_ShowsLogin(){
        
        //Chamo o makeSUT
        let sut = makeSUT(isLoggedIn: false)
        
        XCTAssert(sut.state == .login)
    }
    
}

private extension AppViewModelTests {
    
    func makeSUT(isLoggedIn: Bool) -> AppViewModel {
        
        // Chama uma seessionService
        let sessionService: SessionService = StubSessionService(user: isLoggedIn ? .init() : nil )
        
        //retorna um AppViewModel que contêm ou não um User.
        // Se o estado for logado meu StubSessionService automaticamente passa um user.
        
        
        return .init(sessionService: sessionService)
    }
    
    final class StubSessionService: SessionService {
        
        private(set) var user: User?
        
        init (user: User?) {
            self.user = user
        }
        
    }
    
    
}
