//
//  CustomAlertView.swift
//  The Prolific Library
//
//  Created by Gungor Basa on 5/16/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import Foundation
import SCLAlertView

enum AlertViewType {
    case Success
    case Error
    case Warning
}


class CustomAlertView {
    static func show(title: String, text: String, type: AlertViewType, duration: Float) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        switch type {
        case .Success:
            alertView.showSuccess(title, subTitle: text, duration: TimeInterval(duration))
        case .Error:
            alertView.showError(title, subTitle: text, duration: TimeInterval(duration))
        default:
            alertView.showWarning(title, subTitle: text, duration: TimeInterval(duration))
        }
    }
    
    static func show(title: String, text: String, type: AlertViewType, completion: @escaping (Bool) -> Void) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Yes") {
            completion(true)
        }
        alertView.addButton("No") {
            completion(false)
        }
        
        switch type {
        case .Success:
            alertView.showSuccess(title, subTitle: text)
        case .Error:
            alertView.showError(title, subTitle: text)
        default:
            alertView.showWarning(title, subTitle: text)
        }
    }
    
    static func showWithTextField(title: String, text: String,
                textFieldPlaceholders: [String], yesButton: String,
                noButton: String,  completion: @escaping (Bool, [String: String]?) -> Void) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let count = textFieldPlaceholders.count
        var acs: [String: UITextField] = [:]
        
        for i in 0..<count {
            acs[textFieldPlaceholders[i]] = alertView.addTextField(textFieldPlaceholders[i])
        }
        
        alertView.addButton(yesButton) {
            var results = [String: String]()
            for item in acs {
                results[item.key] = item.value.text
            }
//            results = acs.map{ (key, value) in (key, value.text) }
            completion(true, (results as [String: String]))
        }
        
        alertView.addButton(noButton) {
            completion(false, nil)
        }
        
        
        alertView.showInfo(title, subTitle: text)
    }
}
