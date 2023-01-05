//
//  ThemeManager.swift
//  CS193p_Assignment6
//
//  Created by Jakub Łata on 05/01/2023.
//

import SwiftUI

struct ThemeManager: View {
    
    @EnvironmentObject var store: ThemeStore
    
    @State private var editMode: EditMode = .inactive
    
    //Dictionary for keeping track what games are attributed to which themes
    @State private var allThemeGames = [Theme : EmojiMemoryGame]()
    
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: getMemorizeGame(theme: theme)) {
                        themeItemRow(theme: theme)
                    }
                }
            }
            
        }
        
    }
    
    private func emojis (from theme: Theme) -> String {
        
        var emojiString = ""
        
        theme.emojiSet.forEach() { emoji in
            emojiString += emoji
        }
        
        return emojiString
    }
    
    private func themeItemRow(theme: Theme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .foregroundColor(Color(rgbaColor: theme.color))
            HStack {
                if theme.numberOfPairs == theme.emojiSet.count {
                    Text("All of \(emojis(from: theme))")
                } else {
                    Text("\(String(theme.numberOfPairs)) pairs from \(emojis(from: theme))")
                }
            }
        }
    }
    
    //Start a new game if there are no current games with the given theme or display the currently existing game
    private func getMemorizeGame(theme: Theme) -> some View {
        if allThemeGames[theme] == nil {
            let newGame = EmojiMemoryGame(theme: theme)
            //update the binded dictionary
            allThemeGames.updateValue(newGame, forKey: theme)
            return EmojiMemoryGameView(game: newGame)
        }
        return EmojiMemoryGameView(game: allThemeGames[theme]!)
    }
    
}

struct ThemeManager_Previews: PreviewProvider {
    static var previews: some View {
        ThemeManager()
    }
}
