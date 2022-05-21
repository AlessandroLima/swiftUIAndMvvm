//
//  ContentView.swift
//  swiftMVVM
//
//  Created by Alessandro Teixeira Lima on 20/05/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var model: ContentViewModel
    
    init(model: ContentViewModel){
        self.model = model
    }

    var body: some View {
        Text(model.state.isLoading ? "Carregando..." : model.state.message)
            .onAppear(perform: self.model.loadData)
            .padding()
    }
    
    private var loadingOverlay: some View {
        Group {
            if model.state.isLoading {
                Text("Carregando...")
            }
        }
    }
    
    
}

struct ContentViewState {
    var message = ""
    var isLoading = false

}

class ContentViewModel: ObservableObject {
//    private(set) var state: ContentViewState {
//        didSet {
//            objectWillChange.send()
//        }
//    }

    // A implementação abaixo funciona como a dew cima
    
    @Published  private(set) var state: ContentViewState
    
    init(initialState: ContentViewState = .init()) {
        state = initialState
    }
    
    func loadData() {
        state.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)){ [self] in
            self.state.isLoading = false
            self.state.message = "Acabei de carregar..."
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView(model: .init(initialState: .init(isLoading: true)))
                .previewDisplayName("Loading")
            ContentView(model: .init(initialState: .init(message: "Acabei de carregar!", isLoading: false)))
                .previewDisplayName("Loaded")
        }
        
    }
}
