//
//  Utilties.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 06/11/24.
//

import Foundation
import UIKit

extension UIColor {
    // Convert hex string to UIColor
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Check for hash (#) at the beginning of the string
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        // Ensure the string is 6 characters (RGB) or 8 characters (RGBA)
        let length = hexSanitized.count
        guard length == 6 || length == 8 else {
            self.init(white: 0, alpha: 1) // Default to white if the hex value is invalid
            return
        }
        
        // Default to full opacity (alpha = 1) if no alpha is provided
        var rgba: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgba)
        
        if length == 6 {
            self.init(
                red: CGFloat((rgba & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgba & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgba & 0x0000FF) / 255.0,
                alpha: 1.0
            )
        } else {
            self.init(
                red: CGFloat((rgba & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgba & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgba & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgba & 0x000000FF) / 255.0
            )
        }
    }
}

// Alert with custom message
extension UIViewController {
    func showAlert(title: String = "Alert", message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//String utilties
extension String {
    func formatPhoneNumber() -> String {
        guard self.contains("+") && self.count > 3 else { return self }
        let countryCode = self.prefix(3)
        let restOfNumber = self.dropFirst(3)
        _ = "\(countryCode)-\(restOfNumber)"
        return "\(countryCode)-\(restOfNumber)"
    }
}

extension UIImageView {
    /// Adds a blur effect if `isBlurred` is true, removes it otherwise.
    func setBlur(_ isBlurred: Bool) {
        if isBlurred {
            // Check if a blur effect is already applied
            if !self.subviews.contains(where: { $0 is UIVisualEffectView }) {
                let blurEffect = UIBlurEffect(style: .dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = self.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.addSubview(blurEffectView)
            }
        } else {
            // Remove any existing blur effect
            if let blurEffectView = self.subviews.first(where: { $0 is UIVisualEffectView }) {
                blurEffectView.removeFromSuperview()
            }
        }
    }
}
