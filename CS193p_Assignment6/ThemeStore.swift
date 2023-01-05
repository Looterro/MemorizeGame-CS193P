//
//  ThemeStore.swift
//  CS193p_Assignment6
//
//  Created by Jakub Łata on 05/01/2023.
//

import SwiftUI

struct Theme: Codable, Identifiable, Hashable {
    var name: String
    var emojiSet: [String]
    var numberOfPairs: Int
    var color: RGBAColor
    var id: Int
    
    init(name: String, emojiSet: [String], numberOfPairs: Int, color: RGBAColor, id: Int) {
        self.name = name
        self.emojiSet = emojiSet
        //Protect against number being higher than emojiSet array length
        self.numberOfPairs = numberOfPairs > emojiSet.count ? emojiSet.count : numberOfPairs
        self.color = color
        self.id = id
    }
    
    //convert set of emojis to string
    var emojis: String {
        
        var emojiString = ""
        
        emojiSet.forEach() { emoji in
            emojiString += emoji
        }
        
        return emojiString
    }
}

struct RGBAColor: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [Theme]()
    
    init(named name: String) {
        self.name = name
        
        if themes.isEmpty {
            print("Using built-in themes")
            insertTheme(named: "Vehicles", numberOfPairs: 6, emojiSet: ["✈️", "🚂", "🚀", "🚗", "🛵", "🚲"], color: Color(rgbaColor: RGBAColor(255, 143, 20, 1)))
            insertTheme(named: "Sports", numberOfPairs: 5, emojiSet: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏉", "🥏", "🏐", "🎱"], color: Color(rgbaColor: RGBAColor(37, 75, 240, 1)))
            insertTheme(named: "Animals", numberOfPairs: 8, emojiSet: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐵"], color: Color(rgbaColor: RGBAColor(229, 108, 204, 1)))
            
        } else {
            print("Successfully loaded themes from UserDefaults")
        }
    }
    
    
    //MARK: - Intents
    
    //get a theme at a certain index. If requresting for a theme out of range it returns something within range
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    //Doesnt allow for removing a theme file if there is only one left
    @discardableResult
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
    
    func insertTheme(named name: String, numberOfPairs: Int = 2, emojiSet: [String]? = nil, color: Color = Color(rgbaColor: RGBAColor(100, 100, 50, 1)), at index: Int = 0) {
        let uniqueId = (themes.max(by: { $0.id < $1.id })?.id ?? 0 ) + 1
        let theme = Theme(name: name, emojiSet: emojiSet ?? [], numberOfPairs: numberOfPairs, color: RGBAColor(color: color), id: uniqueId)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
    
}

