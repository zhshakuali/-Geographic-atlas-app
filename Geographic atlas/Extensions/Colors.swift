//
//  Colors.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 13.05.2023.
//

import UIKit

extension UIColor {
    struct Foreground {
        static let secondary: UIColor = {
            let color = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
            return .init(color: color)
        }()
        
        static let primary: UIColor = {
            let color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            return .init(color: color)
        }()
        
        static let accentColor: UIColor = {
            let color = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            return .init(color: color)
        }()
        
        static let contentViewColor: UIColor = {
            let color = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9764705882, alpha: 1)
            return .init(color: color)
        }()
    }
}

extension UIColor {
    convenience init(color: UIColor) {
        self.init { traitCollection -> UIColor in
            color
        }
    }
}
