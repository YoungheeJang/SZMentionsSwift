//
//  ExampleMention.swift
//  SZMentionsExample
//
//  Created by Steven Zweier on 1/12/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

import UIKit
import SZMentionsSwift

struct ExampleMention: CreateMention {
    var id: String = ""
    var name: String = ""
    var range: NSRange = NSRange(location: 0, length: 0)
}
