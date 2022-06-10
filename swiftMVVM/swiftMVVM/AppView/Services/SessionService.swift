import Combine
import Foundation

protocol SessionService: LoginService {
    var userPublisher: AnyPublisher<User?, Never> { get }
    func logout()
}

final class FakeSessionService: SessionService {
    
    private let userSubject: CurrentValueSubject<User?, Never>
    
    private(set) lazy var userPublisher = userSubject.eraseToAnyPublisher()
    
    var user: User? { userSubject.value }
    
    init (user: User?) {
        
        self.userSubject = .init(user)
    }
    
    func login(email: String,
               password: String,
               completion: @escaping (Error?) -> Void) {
        userSubject.send(.init(User(email:email , nome: "Alessandro")))
    }
    
    func logout() {
        userSubject.send(nil)
    }
    
    
}
