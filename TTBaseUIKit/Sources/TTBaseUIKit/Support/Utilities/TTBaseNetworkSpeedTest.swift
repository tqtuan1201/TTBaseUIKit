//
//  TTBaseNetworkSpeedTest.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 3/14/22.
//  Copyright © 2022 Truong Quang Tuan. All rights reserved.
//

import Foundation

public protocol NetworkSpeedProviderDelegate: AnyObject {
    func callWhileSpeedChange(networkStatus: NetworkStatus, megabytesPerSecond: CGFloat)
}

public enum NetworkStatus :String {case poor; case good; case disConnected}

open class TTBaseNetworkSpeedTest : NSObject {
    
    weak public var delegate: NetworkSpeedProviderDelegate?
    public var callWhileSpeedChange:( (_ networkStatus: NetworkStatus,_ megabytesPerSecond: CGFloat) -> () )?
    
    fileprivate var startTime = CFAbsoluteTime()
    fileprivate var stopTime = CFAbsoluteTime()
    fileprivate var bytesReceived: CGFloat = 0
    fileprivate var testURL:String = "https://www.google.com/"
    
    fileprivate var speedTestCompletionHandler: ((_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void)? = nil
    fileprivate var timerForSpeedTest:Timer?
    fileprivate var timeLoop:Double = 0.0
    
    public init(withUrl urlString:String, timeLoop:Double) {
        self.testURL = urlString
        self.timeLoop = timeLoop
    }
    
    public init(withUrl urlString:String) {
        self.testURL = urlString
    }

    
    public init(witTimeLoop timeLoop:Double) {
        self.timeLoop = timeLoop
    }
    
    public override init() {
    }
    
    public func onStart() {
        if self.timeLoop <= 0.0 {
            self.testForSpeed()
        } else {
            self.timerForSpeedTest = Timer.scheduledTimer(timeInterval: self.timeLoop, target: self, selector: #selector(self.testForSpeed), userInfo: nil, repeats: true)
            self.timerForSpeedTest?.fire()
        }
    }
    
    public func onStop(){
        self.timerForSpeedTest?.invalidate()
    }
    
    @objc fileprivate func testForSpeed()
    {
        self.testDownloadSpeed(withTimout: 2.0, completionHandler: {(_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void in
            TTBaseFunc.shared.printLog(object: "::TTBaseNetworkSpeedTest %0.1f; KbPerSec = \(megabytesPerSecond)")
            if (error as NSError?)?.code == -1009 {
                self.delegate?.callWhileSpeedChange(networkStatus: .disConnected, megabytesPerSecond: megabytesPerSecond)
                self.callWhileSpeedChange?(.disConnected, megabytesPerSecond)
            } else if megabytesPerSecond == -1.0 {
                self.delegate?.callWhileSpeedChange(networkStatus: .poor, megabytesPerSecond: megabytesPerSecond)
                self.callWhileSpeedChange?(.poor, megabytesPerSecond)
            } else {
                self.delegate?.callWhileSpeedChange(networkStatus: .good, megabytesPerSecond: megabytesPerSecond)
                self.callWhileSpeedChange?(.good, megabytesPerSecond)
            }
        })
    }
    
}

//MARK:// URLSessionDataDelegate
extension TTBaseNetworkSpeedTest: URLSessionDataDelegate, URLSessionDelegate {
    
    fileprivate func testDownloadSpeed(withTimout timeout: TimeInterval, completionHandler: @escaping (_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void) {
        
        // you set any relevant string with any file
        guard let urlForSpeedTest = URL(string: self.testURL) else { return }
        
        self.startTime = CFAbsoluteTimeGetCurrent()
        self.stopTime = startTime
        self.bytesReceived = 0
        self.speedTestCompletionHandler = completionHandler
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        session.dataTask(with: urlForSpeedTest).resume()
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bytesReceived += CGFloat(data.count)
        stopTime = CFAbsoluteTimeGetCurrent()
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let elapsed = (stopTime - startTime) //as? CFAbsoluteTime
        let speed: CGFloat = elapsed != 0 ? bytesReceived / (CGFloat(CFAbsoluteTimeGetCurrent() - startTime)) / 1024.0 : -1.0
        // treat timeout as no error (as we're testing speed, not worried about whether we got entire resource or not
        if error == nil || ((((error as NSError?)?.domain) == NSURLErrorDomain) && (error as NSError?)?.code == NSURLErrorTimedOut) {
            speedTestCompletionHandler?(speed, nil)
        }
        else {
            speedTestCompletionHandler?(speed, error)
        }
    }
}
