//
//  ViewController.swift
//  KeyboardObserver-RxSwift
//
//  Created by Tomoya Hirano on 11/16/2016.
//  Copyright (c) 2016 Tomoya Hirano. All rights reserved.
//

import UIKit
import KeyboardObserver_RxSwift

final class ViewController: UIViewController {
  //private let disposeBag = DisposeBag()
  private var keyboardObserver = KeyboardObserver()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    subscribe

//    keyboardObserver.rx_event.subscribe(onNext: { (event) in
//      print(event.state)
//      print(event.info)
//    }).addDisposableTo(disposeBag)
    
    //method handler
    keyboardObserver.willHide { (event) in
      print("willhide")
    }.didHide { (event) in
      print("didHide")
    }.willShow { (event) in
      print("willshow")
    }.didShow { (eevnt) in
      print("ddidshow")
    }
    
  }
}

