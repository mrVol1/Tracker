//
//  TransformerValue.swift
//  Tracker
//
//  Created by Eduard Karimov on 12/05/2024.
//

import UIKit
import CoreData

final class TransformerValue: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [WeekDay] else { return nil }
        return try? JSONEncoder().encode(days)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([WeekDay].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            TransformerValue(),
            forName: NSValueTransformerName("TransformerValue")
        )
    }
}
