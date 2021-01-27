//
//  SwiftPortfolioApp.swift
//  SwiftPortfolio
//
//  Created by User23198271 on 10/28/20.
//

import SwiftUI

@main
struct SwiftPortfolioApp: App {
    // give app access to DataController instance
    @StateObject var dataController: DataController
    // create dataController object
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    func save(_ note: Notification) {
        dataController.save()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // send data controller in to allow code to manipulate it
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
        }
    }
}
