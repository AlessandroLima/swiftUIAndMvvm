import XCTest
import Combine
@testable import swiftMVVM

final class AppViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    func test_WhenUserIsLoggedIn_ShowsLogedArea(){
        
        let (sut, _) = makeSUT(isLoggedIn: true)
        
        XCTAssert(sut.state?.isLogeedArea == true)
        
    }
    
    func test_WhenUserIsNotLoggedIn_ShowsLogin(){
        
        //Chamo o makeSUT
        let (sut, _) = makeSUT(isLoggedIn: false)
        
        XCTAssert(sut.state?.isLogin == true)
    }
    
    func test_WhenUserLogsIn_ShowsLoggedArea(){
        
        //Chamo o makeSUT
        let (sut, service) = makeSUT(isLoggedIn: false)
        
        service.login(email: "",
                      password: "",
                      completion: {_ in })
        
        XCTAssert(sut.state?.isLogeedArea == true)
    }
    
    func test_WhenUserLogsOut_ShowsLoginArea(){
        
        //Chamo o makeSUT
        let (sut, service) = makeSUT(isLoggedIn: true)
        
        service.logout()
        
        XCTAssert(sut.state?.isLogin == true)
    }
    
    func test_whenUserIsLoggedInAndUserInfoChanged_andStateIsNotUpdated() {
        let (sut, service) = makeSUT(isLoggedIn: true)
        
        var sinkCount = 0
        
        var cancellabe: AnyCancellable? = sut.$state.sink{ _ in
            sinkCount +=  1
        }
        
        service.user?.nome = "Alexandre"
        
        XCTAssertEqual(sinkCount    , 1)
        
        cancellabe = nil
    }
    
    
    
}

private extension AppViewModelTests {
    
    func makeSUT(isLoggedIn: Bool) -> (AppViewModel, StubSessionService) {
        
        // Chama uma seessionService
        let sessionService: StubSessionService = StubSessionService(user: isLoggedIn ? .init(User(email: "", nome: "" )) : nil )
        
        //retorna um AppViewModel que contêm ou não um User.
        // Se o estado for logado meu StubSessionService automaticamente passa um user.
        
        
        return (AppViewModel(sessionService: sessionService),sessionService)
    }
    
    final class StubSessionService: SessionService {
        
        private let userSubject: CurrentValueSubject<User?, Never>
        
        private(set) lazy var userPublisher = userSubject.eraseToAnyPublisher()
        
        var user: User? {
    
            get { self.userSubject.value }
            set { userSubject.send(newValue)}
        }
        
        init (user: User?) {
            self.userSubject = .init(user)
        }
        
        func login(email: String,
                   password: String,
                   completion: @escaping (Error?) -> Void) {
            userSubject.send(.init(User(email: "", nome:"")))
        }
        
        func logout() {
            userSubject.send(nil)
        }
        
        
    }
    
}

//MARK: - Helpers

private extension AppViewState {
    var isLogin: Bool {
        guard  case .login = self else { return false}
        return true
    }
    
    var isLogeedArea: Bool {
        guard  case .loggedArea = self else { return false}
        return true
    }
}
