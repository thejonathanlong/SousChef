//
//  NSLinguisticTagger+SousChefAdditions.swift
//  SousChef
//
//  Created by Jonathan Long on 3/17/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import Foundation

extension NSLinguisticTagger {
	func enumerateTagsAndTokens(in range: NSRange, unit: NSLinguisticTaggerUnit, scheme: NSLinguisticTagScheme, options: NSLinguisticTagger.Options = [], using block: (NSLinguisticTag, String, NSRange, UnsafeMutablePointer<ObjCBool>) -> Swift.Void) {
		enumerateTags(in: range, unit: unit, scheme: scheme, options: options) { (tagOrNil, range, stop) in
			guard let text = self.string else { print("Did you forget to give the tagger some text? The string was nil."); return }
			guard let tag = tagOrNil else { print("The tag at range \(range) was nil..."); return }
			
			let start = text.index(text.startIndex, offsetBy: range.location)
			let end = text.index(text.startIndex, offsetBy: (range.location + range.length))
			let tokenInQuestion = String(text[start..<end])
			
			block(tag, tokenInQuestion, range, stop)
		}
	}
}
