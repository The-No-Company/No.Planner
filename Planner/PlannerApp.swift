//
//  PlannerApp.swift
//  Planner
//
//  Created by Michael Safir on 13.10.2021.
//

import SwiftUI

@main
struct PlannerApp: App {
    var body: some Scene {
        WindowGroup {
            Start()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}


extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        
        let dragGesture = UISwipeGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        dragGesture.requiresExclusiveTouchType = false
        dragGesture.cancelsTouchesInView = false
        dragGesture.delegate = self
        
        window.addGestureRecognizer(tapGesture)
        window.addGestureRecognizer(dragGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
