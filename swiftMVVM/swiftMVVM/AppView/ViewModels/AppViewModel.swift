import Combine
import Foundation

final class AppViewModel: ObservableObject {
    
    @Published private(set) var state: AppViewState?
    
    private var userCancellable: AnyCancellable?
    
    init(sessionService: SessionService){
        
        let  viewModel = LoginViewModel(service: sessionService,
                                       loginDidSuccessed: {})
     
        userCancellable = sessionService.userPublisher
            .map { $0 != nil }
            .removeDuplicates()
            .sink{ [weak self] isLoggedIn in
            
            self?.state = isLoggedIn
            ? .loggedArea(sessionService)
            : .login(viewModel)
            
        }
    }
}
