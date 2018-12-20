
//
//  ThemeManager.swift
//  MySwiftHub
//
//  Created by 黄永乐 on 2018/12/19.
//  Copyright © 2018 黄永乐. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTheme
import RAMAnimatedTabBarController
import KafkaRefresh
import ChameleonFramework


let themeService = ThemeType.service(initial: ThemeType.currentTheme())


protocol Theme {
    var primary: UIColor { get }
    var primaryDark: UIColor { get }
    var secondary: UIColor { get }
    var secondaryDark: UIColor { get }
    var separatorColor: UIColor { get }
    var text: UIColor { get }
    var textGray: UIColor { get }
    var background: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var barStyle: UIBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    var blurStyle: UIBlurEffect.Style { get }
    init(colorTheme: ColorTheme)
}


struct LightTheme: Theme {
    let primary = UIColor.white
    let primaryDark = UIColor.flatWhite
    var secondary: UIColor = .flatRed
    var secondaryDark: UIColor = .flatRedDark
    let separatorColor: UIColor = .flatWhite
    let text = UIColor.flatBlack
    let textGray = UIColor.flatGray
    let background: UIColor = .white
    let statusBarStyle: UIStatusBarStyle = .default
    let barStyle = UIBarStyle.default
    let keyboardAppearance: UIKeyboardAppearance = .light
    let blurStyle: UIBlurEffect.Style = .extraLight
    
    init(colorTheme: ColorTheme) {
        secondary = colorTheme.color
        secondaryDark = colorTheme.colorDark
    }
}

struct DarkTheme: Theme {
    let primary = UIColor.flatBlack
    let primaryDark = UIColor.flatBlackDark
    var secondary: UIColor = .flatRed
    var secondaryDark: UIColor = .flatRedDark
    let separatorColor: UIColor = .flatBlackDark
    let text = UIColor.flatWhite
    let textGray = UIColor.flatGray
    let background: UIColor = .flatBlack
    let statusBarStyle: UIStatusBarStyle = .lightContent
    let barStyle = UIBarStyle.black
    let keyboardAppearance: UIKeyboardAppearance = .dark
    let blurStyle: UIBlurEffect.Style = .dark
    
    init(colorTheme: ColorTheme) {
        secondary = colorTheme.color
        secondaryDark = colorTheme.colorDark
    }
}


enum ColorTheme: Int {
    case red, green, blue, skyBlue, magenta, purple, watermelon, lime, pink
    static let allValues = [red, green, blue, skyBlue, magenta, purple, watermelon, lime, pink]
    
    var color: UIColor {
        switch self {
        case .red: return .flatRed
        case .green: return .flatGreen
        case .blue: return .flatBlue
        case .skyBlue: return .flatSkyBlue
        case .magenta: return .flatMagenta
        case .purple: return .flatPurple
        case .watermelon: return .flatWatermelon
        case .lime: return .flatLime
        case .pink: return .flatPink
        }
    }
    
    var colorDark: UIColor {
        switch self {
        case .red: return .flatRedDark
        case .green: return .flatGreenDark
        case .blue: return .flatBlueDark
        case .skyBlue: return .flatSkyBlueDark
        case .magenta: return .flatMagentaDark
        case .purple: return .flatPurpleDark
        case .watermelon: return .flatWatermelonDark
        case .lime: return .flatLimeDark
        case .pink: return .flatPinkDark
        }
    }
    
    var title: String {
        switch self {
        case .red: return "Red"
        case .green: return "Green"
        case .blue: return "Blue"
        case .skyBlue: return "Sky Blue"
        case .magenta: return "Magenta"
        case .purple: return "Purple"
        case .watermelon: return "Watermelon"
        case .lime: return "Lime"
        case .pink: return "Pink"
        }
    }
}


enum ThemeType: ThemeProvider {
    case light(color: ColorTheme)
    case dark(color: ColorTheme)
    
    var associatedObject: Theme {
        switch self {
        case let .light(color):
            return LightTheme(colorTheme: color)
        case let .dark(color):
            return DarkTheme(colorTheme: color)
        }
    }
    
    var isDark: Bool {
        switch self {
        case .dark:
            return true
        default:
            return false
        }
    }
    
    func toggle() -> ThemeType {
        var theme: ThemeType
        switch self {
        case let .light(color):
            theme = ThemeType.dark(color: color)
        case let .dark(color):
            theme = ThemeType.light(color: color)
        }
        theme.save()
        return theme
    }
    
    func withColor(color: ColorTheme) -> ThemeType {
        var theme: ThemeType
        switch self {
        case let .light(color):
            theme = ThemeType.light(color: color)
        case let .dark(color):
            theme = ThemeType.dark(color: color)
        }
        theme.save()
        return theme
    }
}

extension ThemeType {
    
    static func currentTheme() -> ThemeType {
        let defaults = UserDefaults.standard
        let isDark = defaults.bool(forKey: "IsDarkKey")
        let colorTheme = ColorTheme(rawValue: defaults.integer(forKey: "ThemeKey")) ?? ColorTheme.red
        let theme = isDark ? ThemeType.dark(color: colorTheme) : ThemeType.light(color: colorTheme)
        theme.save()
        return theme
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(isDark, forKey: "IsDarkKey")
        switch self {
        case let .light(color):
            defaults.set(color.rawValue, forKey: "ThemeKey")
        case let .dark(color):
            defaults.set(color.rawValue, forKey: "ThemeKey")
        }
    }
}
