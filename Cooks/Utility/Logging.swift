//
//  Logging.swift
//  SousChef
//
//  Created by Jonathan Long on 4/26/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import Foundation
import os.log

let logt = OSLog(subsystem: "com.jlo.souschef", category: "SousChef")

func chefLog(message: StaticString, _ args: CVarArg...) {
	os_log(message, log: logt, type: .debug, args)
}
