//
//  ExampleAccessoryView.swift
//  SZMentionsExample
//
//  Created by Steven Zweier on 1/11/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

import UIKit
import SZMentionsSwift
import Hakawai

class CustomParagraphStyleValue:NSObject {
    
    static func valueWithParagraph() -> NSMutableParagraphStyle {
        let paragraph = NSMutableParagraphStyle()
        paragraph.paragraphSpacing = 3
        return paragraph
    }
}

class ExampleAccessoryView: UIView {
    struct Attribute: AttributeContainer {
        var name: String
        var value: NSObject
    }
    public let textView = TextView()
    private let mentionsTableView = UITableView()
    private let mentionAttributes: [AttributeContainer] = [
        Attribute(
            name: NSAttributedStringKey.foregroundColor.rawValue,
            value: UIColor.black),
        Attribute(
            name: NSAttributedStringKey.paragraphStyle.rawValue,
            value: CustomParagraphStyleValue.valueWithParagraph()),
        Attribute(
            name: NSAttributedStringKey.font.rawValue,
            value: UIFont(name: "AppleSDGothicNeo-Light", size: 12)!),
        Attribute(
          name: HKWRoundedRectBackgroundAttributeName,
          value: HKWRoundedRectBackgroundAttributeValue.init(backgroundColor: UIColor(red: 0, green: 0.9137, blue: 1, alpha: 1.0)))
    ]
    private let defaultAttributes: [AttributeContainer] = [
        Attribute(
            name: NSAttributedStringKey.foregroundColor.rawValue,
            value: UIColor.gray),
        Attribute(
            name: NSAttributedStringKey.paragraphStyle.rawValue,
            value: CustomParagraphStyleValue.valueWithParagraph()),
        Attribute(
            name: NSAttributedStringKey.font.rawValue,
            value: UIFont(name: "AppleSDGothicNeo-Light", size: 12)!),
        Attribute(
          name: HKWRoundedRectBackgroundAttributeName,
          value: HKWRoundedRectBackgroundAttributeValue.init(backgroundColor: UIColor.clear))
    ]
    public var dataManager: ExampleMentionsTableViewDataManager?
    
    init(delegate: UITextViewDelegate) {
        super.init(frame: .zero)
        autoresizingMask = .flexibleHeight
        let mentionsListener = MentionListener(mentionTextView: textView,
                                                    attributesForMention: { mention in self.mentionAttributes },
                                                    defaultTextAttributes: defaultAttributes,
                                                    spaceAfterMention: true,
                                                    hideMentions: hideMentions,
                                                    didHandleMentionOnReturn: didHandleMentionOnReturn,
                                                    showMentionsListWithString: showMentionsListWithString)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = mentionsListener
        addSubview(textView)
        addConstraintsToTextView(textView)
        textView.text = "Test Steven Zweier mention"
        
        let mention = ExampleMention(id: "", name: "Steven Zweier",
                                       range: NSRange(location: 5, length: 13))
        mentionsListener.insertExistingMentions([mention])
        
        dataManager = ExampleMentionsTableViewDataManager(
            mentionTableView: mentionsTableView,
            mentionsListener: mentionsListener)
        
        setupTableView(mentionsTableView, dataManager: dataManager)
        backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView(_ tableView: UITableView, dataManager: ExampleMentionsTableViewDataManager?) {
        mentionsTableView.translatesAutoresizingMaskIntoConstraints = false
        mentionsTableView.backgroundColor = .blue
        mentionsTableView.delegate = dataManager
        mentionsTableView.dataSource = dataManager
    }
    
    private func addConstraintsToTextView(_ textView: UITextView) {
        removeConstraints(constraints)
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "|-5-[textView]-5-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["textView": textView]) +
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|-5-[textView(100)]-5-|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: ["textView": textView])
        )
    }
    
    private func setupTextView(_ textView: UITextView, delegate: MentionListener) {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = delegate
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.size.width, height: mentionsTableView.superview == nil ? 40 : 140)
    }
}

extension ExampleAccessoryView {
    func hideMentions() {
        if mentionsTableView.superview != nil {
            mentionsTableView.removeFromSuperview()
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-5-[textView(100)]-5-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["textView": textView])
            )
        }
        dataManager?.filter("")
    }
    func didHandleMentionOnReturn() -> Bool { return false }
    func showMentionsListWithString(mentionsString: String, trigger: String) {
        if mentionsTableView.superview == nil {
            removeConstraints(constraints)
            addSubview(mentionsTableView)
            addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "|-5-[tableview]-5-|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: ["tableview": mentionsTableView]) +
                    NSLayoutConstraint.constraints(
                        withVisualFormat: "|-5-[textView]-5-|",
                        options: NSLayoutFormatOptions(rawValue: 0),
                        metrics: nil,
                        views: ["textView": textView]) +
                    NSLayoutConstraint.constraints(
                        withVisualFormat: "V:|-5-[tableview(100)][textView(100)]-5-|",
                        options: NSLayoutFormatOptions(rawValue: 0),
                        metrics: nil,
                        views: ["textView": textView, "tableview": mentionsTableView])
            )
        }
        
        dataManager?.filter(mentionsString)
    }
}

