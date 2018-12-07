//
//  ExampleViewController.swift
//  SZMentionsExample
//
//  Created by Steven Zweier on 1/11/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

import UIKit
import SZMentionsSwift
import SnapKit

class ExampleViewController: UIViewController, UITextViewDelegate {

    private var myInputAccessoryView: ExampleAccessoryView!

    init() {
        super.init(nibName: nil, bundle: nil)
        myInputAccessoryView = ExampleAccessoryView(delegate: self)
    }
    
    let label = UILabel()
    
    override func viewDidLoad() {
        let button = UIButton()
        
        
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        label.text = "data"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        
        self.view.addSubview(button)
        self.view.addSubview(label)
        
        button.snp.makeConstraints{
            $0.top.left.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0))
        }
        label.snp.makeConstraints{
            $0.top.equalTo(button.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
        }
    }
    
    @objc func buttonClick() {
        // TODO : 정리 필요.
        label.text = myInputAccessoryView.textView.text
        var text = myInputAccessoryView.textView.text as NSString?
        let mentions = myInputAccessoryView.dataManager?.listener.mentions.sorted{ $0.range.location > $1.range.location }
        for mention in mentions! {
          let temp = text?.replacingCharacters(in: mention.range, with: "@{12358347872342342|\(mention.object.name)}")
          text = temp as NSString?
      }
      label.text = String(text!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var inputAccessoryView: UIView {
        return myInputAccessoryView
    }

    override var canBecomeFirstResponder : Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
}
