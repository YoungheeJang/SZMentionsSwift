//
//  TextView.swift
//  SZMentionsExample
//
//  Created by YH.Jang on 05/12/2018.
//  Copyright © 2018 Steven Zweier. All rights reserved.
//

import UIKit
import Hakawai

class TextView: UITextView {
  
  convenience init() {
    let manager = HKWLayoutManager()
    let container = NSTextContainer(size: CGSize(width: UIScreen.main.bounds.size.width, height: .greatestFiniteMagnitude))
    container.widthTracksTextView = true
    container.heightTracksTextView = false
    manager.addTextContainer(container)
    let storage = NSTextStorage()
    storage.addLayoutManager(manager)
    self.init(frame: .zero, textContainer: container)
  }
  
}
