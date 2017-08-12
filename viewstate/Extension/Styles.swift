//
//  Created by Christopher Trott on 11/25/15.
//  Copyright © 2015 twocentstudios. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: Float = 1.0) {
        let red = max(min(CGFloat(r)/255.0, 1.0), 0.0)
        let green = max(min(CGFloat(g)/255.0, 1.0), 0.0)
        let blue = max(min(CGFloat(b)/255.0, 1.0), 0.0)
        let alpha = max(min(CGFloat(a), 1.0), 0.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(flatGray: Int, a: Float = 1.0) {
        self.init(r: flatGray, g: flatGray, b: flatGray, a: a)
    }
}

struct Color {
    static let
        tint = UIColor(r: 126, g: 206, b: 22)
    
    static let
        danger = UIColor(r: 204, g: 46, b: 46),
        caution = UIColor(r: 240, g: 224, b: 53),
        success = UIColor(r: 51, g: 204, b: 46)
    
    static let
        white = UIColor(flatGray: 255),
        gray00 = UIColor(flatGray: 249),
        gray10 = UIColor(flatGray: 242),
        gray20 = UIColor(flatGray: 230),
        gray35 = UIColor(flatGray: 202),
        gray45 = UIColor(flatGray: 177),
        gray60 = UIColor(flatGray: 146),
        gray75 = UIColor(flatGray: 100),
        gray85 = UIColor(flatGray: 67),
        gray95 = UIColor(flatGray: 33),
        black = UIColor(flatGray: 0)
    
    static let
        clear = UIColor.clear
    
}

struct Font {
    enum TextStyle {
        case title1
        case title2
        case title3
        case headline
        case subheadline
        case body
        case callout
        case footnote
        case caption1
        case caption2
        
        var uikit: String {
            switch self {
            case .title1: return UIFontTextStyle.title1.rawValue
            case .title2: return UIFontTextStyle.title2.rawValue
            case .title3: return UIFontTextStyle.title3.rawValue
            case .headline: return UIFontTextStyle.headline.rawValue
            case .subheadline: return UIFontTextStyle.subheadline.rawValue
            case .body: return UIFontTextStyle.body.rawValue
            case .callout: return UIFontTextStyle.callout.rawValue
            case .footnote: return UIFontTextStyle.footnote.rawValue
            case .caption1: return UIFontTextStyle.caption1.rawValue
            case .caption2: return UIFontTextStyle.caption2.rawValue
            }
        }
    }
    
    static func style(_ style: TextStyle) -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: style.uikit))
    }
}

extension NSMutableParagraphStyle {
    static func centered() -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return paragraphStyle
    }
}
