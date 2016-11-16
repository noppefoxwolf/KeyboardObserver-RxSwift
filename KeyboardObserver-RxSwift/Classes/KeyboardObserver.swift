//
//  KeyboardObserver.swift
//  Pods
//
//  Created by Tomoya Hirano on 2016/11/16.
//
//

import UIKit
import RxSwift
import RxCocoa

public final class KeyboardObserver: NSObject {
  private let disposeBag = DisposeBag()
  public let rx_event = PublishSubject<KeyboardEvent>()
  fileprivate var actions = [KeyboardAction]()
  
  public override init() {
    super.init()
    addObserver()
  }
  
  private func addObserver() {
    let center = NotificationCenter.default
    
    center.rx.notification(Notification.Name.UIKeyboardWillShow, object: nil).subscribe(onNext: { [weak self] (notification) in
      let event = KeyboardEvent(state: .willShow, notification: notification)
      self?.rx_event.onNext(event)
      self?.actions.filter({ $0.state == .willShow }).forEach({ $0.closure(event) })
    }).addDisposableTo(disposeBag)
    
    center.rx.notification(Notification.Name.UIKeyboardWillHide, object: nil).subscribe(onNext: { [weak self] (notification) in
      let event = KeyboardEvent(state: .willHide, notification: notification)
      self?.rx_event.onNext(event)
      self?.actions.filter({ $0.state == .willHide }).forEach({ $0.closure(event) })
    }).addDisposableTo(disposeBag)
    
    center.rx.notification(Notification.Name.UIKeyboardDidHide, object: nil).subscribe(onNext: { [weak self] (notification) in
      let event = KeyboardEvent(state: .didHide, notification: notification)
      self?.rx_event.onNext(event)
      self?.actions.filter({ $0.state == .didHide }).forEach({ $0.closure(event) })
    }).addDisposableTo(disposeBag)
    
    center.rx.notification(Notification.Name.UIKeyboardDidShow, object: nil).subscribe(onNext: { [weak self] (notification) in
      let event = KeyboardEvent(state: .didShow, notification: notification)
      self?.rx_event.onNext(event)
      self?.actions.filter({ $0.state == .didShow }).forEach({ $0.closure(event) })
    }).addDisposableTo(disposeBag)
    
    center.rx.notification(Notification.Name.UIKeyboardDidChangeFrame, object: nil).subscribe(onNext: { [weak self] (notification) in
      let event = KeyboardEvent(state: .didChangeFrame, notification: notification)
      self?.rx_event.onNext(event)
      self?.actions.filter({ $0.state == .didChangeFrame }).forEach({ $0.closure(event) })
    }).addDisposableTo(disposeBag)
    
    center.rx.notification(Notification.Name.UIKeyboardWillChangeFrame, object: nil).subscribe(onNext: { [weak self] (notification) in
      let event = KeyboardEvent(state: .willChangeFrame, notification: notification)
      self?.rx_event.onNext(event)
      self?.actions.filter({ $0.state == .willChangeFrame }).forEach({ $0.closure(event) })
    }).addDisposableTo(disposeBag)
  }
}

public extension KeyboardObserver {
  @discardableResult
  func willShow(_ closure: @escaping ((_ event: KeyboardEvent)->Void)) -> Self {
    actions.append(KeyboardAction(state: .willShow, closure: closure))
    return self
  }
  
  @discardableResult
  func didShow(_ closure: @escaping ((_ event: KeyboardEvent)->Void)) -> Self {
    actions.append(KeyboardAction(state: .didShow, closure: closure))
    return self
  }
  
  @discardableResult
  func willHide(_ closure: @escaping ((_ event: KeyboardEvent)->Void)) -> Self {
    actions.append(KeyboardAction(state: .willHide, closure: closure))
    return self
  }
  
  @discardableResult
  func didHide(_ closure: @escaping ((_ event: KeyboardEvent)->Void)) -> Self {
    actions.append(KeyboardAction(state: .didHide, closure: closure))
    return self
  }
  
  @discardableResult
  func willChangeFrame(_ closure: @escaping ((_ event: KeyboardEvent)->Void)) -> Self {
    actions.append(KeyboardAction(state: .willChangeFrame, closure: closure))
    return self
  }
  
  @discardableResult
  func didChangeFrame(_ closure: @escaping ((_ event: KeyboardEvent)->Void)) -> Self {
    actions.append(KeyboardAction(state: .didChangeFrame, closure: closure))
    return self
  }
}

public enum KeyboardState: String {
  case willShow
  case didShow
  case willHide
  case didHide
  case willChangeFrame
  case didChangeFrame
}

fileprivate struct KeyboardAction {
  var state: KeyboardState
  var closure: ((_ event: KeyboardEvent)->Void)
}

public struct KeyboardEvent {
  private(set) var state: KeyboardState
  private(set) var info: KeyboardInfo
  
  init(state: KeyboardState, notification: Notification) {
    self.state = state
    self.info = KeyboardInfo(notification.userInfo)
  }
}

public struct KeyboardInfo {
  private(set) var frameEnd: CGRect? = nil
  private(set) var isLocal: Bool? = nil
  private(set) var bounds: CGRect? = nil
  private(set) var animationCurve: UIViewAnimationCurve? = nil
  private(set) var centerBegin: CGPoint? = nil
  private(set) var centerEnd: CGPoint? = nil
  private(set) var frameBegin: CGRect? = nil
  private(set) var animationDuration: Double? = nil
  
  init(_ userInfo: [AnyHashable : Any]?) {
    frameEnd = userInfo?["UIKeyboardFrameEndUserInfoKey"] as! CGRect?
    isLocal = userInfo?["UIKeyboardIsLocalUserInfoKey"] as! Bool?
    bounds = userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect?
    animationCurve = (userInfo?["UIKeyboardAnimationCurveUserInfoKey"] as! Int?).map { UIViewAnimationCurve(rawValue: $0) }!
    centerBegin = userInfo?["UIKeyboardCenterBeginUserInfoKey"] as! CGPoint?
    centerEnd = userInfo?["UIKeyboardCenterEndUserInfoKey"] as! CGPoint?
    frameBegin = userInfo?["UIKeyboardFrameBeginUserInfoKey"] as! CGRect?
    animationDuration = userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as! Double?
  }
}
