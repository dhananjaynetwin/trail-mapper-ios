//
//  TMConstants.swift
//  TrailMapper
//
//  Created by Netwin on 09/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit

class TMConstants: NSObject {

    static let kApplicationName                     =       "TrailMapper"
    static let kWsAppUrl                                =       "https:\\"

    static let SCREEN_SIZE: CGRect                =       UIScreen.main.bounds

    //AlertTitle Constants
    static let kAlertTypeOK                             =       "OK"
    static let kAlertTypeCancel                       =       "Cancel"
    static let kAlertTypeYES                            =       "YES"
    static let kAlertTypeNO                             =       "NO"
    static let kAlertHideCancel                       =       ""

    static let kNoInternetConnection              =       "No internet connection"

    // SCIDatabaseDAO will consist full resource path this sqlite file.
    static let TM_DATABASE_NAME               =       "TrailMapper.sqlite"
    static let kTRAIL_MAPPER_TABLE                            =        "trail"

    static let kWS_BASE_URL                              =        ""
    static let kWS_GET_TRAILS                           =       kWS_BASE_URL + "https://gist.github.com/timlinux/272bab60ffd2357921a1d2a8f5395eb2/raw/dffe9fae58cf3af67b787510b72a77bde29e7c9a/trails.json"

}
