//
//  AppConfig.swift
//  Le
//
//  Created by Asif Seraje on 11/22/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class AppConfig: NSObject {
    static let sharedInstance = AppConfig()
    
    struct settingsOptionsTexts {
        static let HEALTH_INFO_TEXT = "Input Health Info"
        static let PROFILE_TEXT = "Profile Details"
        static let FEEDBACK_TEXT = "Send Feedback"
        static let TERMS_CONDITIONS_TEXT = "Terms & Conditions"
        static let PRIVACY_TEXT = "Privacy Policy"
        static let LOG_OUT = "Log Out"
    }
    
    
    struct profileOptionsTexts {
        static let FIRST_NAME_TEXT = "First Name"
        static let LAST_NAME_TEXT = "Last Name"
        static let DATE_OF_BIRTH_TEXT = "Date of Birth"
        static let PHONE_NUMBER_TEXT = "Phone Number"
        static let EMAIL_TEXT = "Email"
    }
    let profileOptions = [profileOptionsTexts.FIRST_NAME_TEXT,
                          profileOptionsTexts.LAST_NAME_TEXT,
                          profileOptionsTexts.DATE_OF_BIRTH_TEXT,
                          profileOptionsTexts.PHONE_NUMBER_TEXT,
                          profileOptionsTexts.EMAIL_TEXT]
    
    struct UserdefaultKeys {
        static let LOGGED_IN_STATUS_KEY = "loginStatus"
        static let GUEST_MODE = "GUEST_MODE"
    }

}
