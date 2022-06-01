import Combine
import Foundation

final class AppViewModel: ObservableObject {
    
    @Published private(set) var state: AppViewState?
    
    private var userCancellable: AnyCancellable?
    
    init(sessionService: SessionService){
        
        let  viewModel = LoginViewModel(service: sessionService,
                                       loginDidSuccessed: {})
     
        userCancellable = sessionService.userPublisher.sink { [weak self] user in
            
            self?.state = user == nil
            ? .login(viewModel)
            : .loggedArea(sessionService    )
            
        }
    }
}
