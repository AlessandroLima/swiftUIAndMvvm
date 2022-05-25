import XCTest
@testable import swiftMVVM


enum AppViewState {
    case login
    case loggedArea
}

struct User {
    
}

import Combine

protocol SessionService: LoginService {
    var user: User? {get}
    var userPublisher: AnyPublisher<User?, Never> { get }
    func logout()
}

final class AppViewModel {
    
    @Published private(set) var state: AppViewState
    private var userCancellable: AnyCancellable?
    
    init(sessionService: SessionService){
        self.state = sessionService.user == nil ? .login : .loggedArea
        userCancellable = sessionService.userPublisher.sink { [weak self] user in
            self?.state = user == nil ? .login : .loggedArea
        }
    }
}



final class AppViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    func test_WhenUserIsLoggedIn_ShowsLogedArea(){
     
        let (sut, _) = makeSUT(isLoggedIn: true)
        
        XCTAssert(sut.state == .loggedArea)
    
    }
    
    func test_WhenUserIsNotLoggedIn_ShowsLogin(){
        
        //Chamo o makeSUT
        let (sut, _) = makeSUT(isLoggedIn: false)
        
        XCTAssert(sut.state == .login)
    }
    
    func test_WhenUserLogsIn_ShowsLoggedArea(){
        
        //Chamo o makeSUT
        let (sut, service) = makeSUT(isLoggedIn: false)
        
        service.login(email: "",
                      password: "",
                      completion: {_ in })
        
        XCTAssert(sut.state == .loggedArea)
    }
    
    func test_WhenUserLogsOut_ShowsLoginArea(){
        
        //Chamo o makeSUT
        let (sut, service) = makeSUT(isLoggedIn: true)
        
        service.logout()
        
        XCTAssert(sut.state == .login)
    }
    
}

private extension AppViewModelTests {
    
    func makeSUT(isLoggedIn: Bool) -> (AppViewModel, StubSessionService) {
        
        // Chama uma seessionService
        let sessionService: StubSessionService = StubSessionService(user: isLoggedIn ? .init() : nil )
        
        //retorna um AppViewModel que contêm ou não um User.
        // Se o estado for logado meu StubSessionService automaticamente passa um user.
        
        
        return (AppViewModel(sessionService: sessionService),sessionService)
    }
    
    final class StubSessionService: SessionService {
        
        private let userSubject: CurrentValueSubject<User?, Never>
        
        private(set) lazy var userPublisher = userSubject.eraseToAnyPublisher()
        
        var user: User? { userSubject.value }
        
        init (user: User?) {
            
            self.userSubject = .init(user)
        }
        
        func login(email: String,
                   password: String,
                   completion: @escaping (Error?) -> Void) {
            userSubject.send(.init())
        }
        
        func logout() {
            userSubject.send(nil)
        }
        
        
    }
    
    
}
