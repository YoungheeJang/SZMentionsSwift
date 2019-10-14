//
//  Array+Mention.swift
//  SZMentionsSwift
//
//  Created by Steve Zweier on 2/1/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

internal extension Array where Element == Mention {
    /**
     @brief returns the mention being edited (if a mention is being edited)
     @param range: the range to look for a mention
     @return Mention?: the mention being edited (if one exists)
     */
    func mentionBeingEdited(at range: NSRange) -> Mention? {
        return filter { NSIntersectionRange(range, $0.range).length > 0 ||
            (range.location + range.length) > $0.range.location &&
            (range.location + range.length) < ($0.range.location + $0.range.length) }.first
    }

    /**
     @brief adjusts the positioning of mentions that exist after the range where text was edited
     @param range: the range where text was changed
     @param text: the text that was changed
     */
    mutating func adjustMentions(forTextChangeAt range: NSRange, text: String) {
        let rangeAdjustment = text.utf16.count - range.length
        mentionsAfterTextEntry(range).forEach { mention in
            var adjustedMention = mention
            adjustedMention.range = NSRange(
                location: mention.range.location + rangeAdjustment,
                length: mention.range.length
            )
            if let index = index(of: mention) {
                self[index] = adjustedMention
            }
        }
    }

    mutating func adjustWordMentions(forTextChangeAt range: NSRange, text _: String) {
        let rangeAdjustment = range.length
        mentionsAfterTextEntry(range).forEach { mention in
            var adjustedMention = mention
            adjustedMention.range = NSRange(
                location: mention.range.location - rangeAdjustment,
                length: mention.range.length
            )
            if let index = index(of: mention) {
                self[index] = adjustedMention
            }
        }
    }

    mutating func reAdjustMentions(text: String) {
        let rangeAdjustmentArry: [Int] = [0, -1, 1, -2, 2]

        forEach { mention in

            var adjustedMention = mention
            adjustedMention.range = NSRange(
                location: mention.range.location,
                length: mention.range.length
            )

            for rangeAdjustment in rangeAdjustmentArry {
                var isEqual = true
                adjustedMention.range.location = mention.range.location + rangeAdjustment
                for (i, char) in mention.object.name.enumerated() {
                    let compareIndex = text.index(text.startIndex, offsetBy: adjustedMention.range.location + i)
                    if text[compareIndex] != char {
                        isEqual = false
                        break
                    }
                }
                if isEqual { break }
            }

            if let index = index(of: mention) {
                self[index] = adjustedMention
            }
        }
    }

    /**
     @brief Determines what mentions exist after a given range
     @param range: the range where text was changed
     @return [Mention]: list of mentions that exist after the provided range
     */
    private func mentionsAfterTextEntry(_ range: NSRange) -> [Mention] {
        return filter { $0.range.location >= range.location + range.length }
    }
}
