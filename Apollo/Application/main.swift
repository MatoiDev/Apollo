//
//  main.swift
//  Apollo
//
//  Created by Matoi on 14.06.2024.
//

import UIKit


let appDelegate: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegate))
