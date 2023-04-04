//
//  TriggerEveryTimer.swift
//  Capturing_Images
//
//  Created by Piyush Manghani on 2/23/22.
//

import Foundation
import Combine

// This is a helper class that creates a `Timer` to repeatedly call a closure.
class TriggerEveryTimer {
    private let triggerEverySecs: Double
    private let updateEverySecs: Double
    private var lastTriggerTime: Date = Date()
    private var timerHandle: AnyCancellable? = nil
    private let onTrigger: (() -> Void)?
    private let onUpdate: ((Double) -> Void)?
    
    init(triggerEvery: Double, onTrigger: @escaping (() -> Void), updateEvery: Double,
         onUpdate: ((Double) -> Void)? = nil) {
        self.triggerEverySecs = triggerEvery
        self.updateEverySecs = updateEvery
        
        self.onTrigger = onTrigger
        self.onUpdate = onUpdate
    }
    
    var isRunning: Bool {
        return timerHandle != nil
    }
    
    func start() {
        lastTriggerTime = Date()
        timerHandle = Timer.publish(every: updateEverySecs, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { date in
                let timeToGoSecs = self.triggerEverySecs -
                    date.timeIntervalSince(self.lastTriggerTime)
                if timeToGoSecs <= 0 {
                    self.onTrigger?()
                    self.lastTriggerTime = date
                }
                self.onUpdate?(timeToGoSecs)
            })
    }
    
    func stop() {
        timerHandle?.cancel()
        timerHandle = nil
    }
}
