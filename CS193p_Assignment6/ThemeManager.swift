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
                    .gesture(editMode == .active ? tapToEditThemeItem(theme: theme) : nil)
                }
                .onDelete { indexSet in
                    indexSet.forEach { store.removeTheme(at: $0) }
                }
                .onMove { fromOffsets, toOffset in
                    store.themes.move(fromOffsets: fromOffsets, toOffset: toOffset)
                }
            }
            .navigationTitle("Memorize Card Game")
            .sheet(item: $themeToEdit) { theme in
                ThemeEditor(theme: $store.themes[theme])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { addThemeButton }
                ToolbarItem { EditButton() }
            }
            .environment(\.editMode, $editMode)
        }
        
    }
    
    private func themeItemRow(theme: Theme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .foregroundColor(Color(rgbaColor: theme.color))
            HStack {
                if theme.numberOfPairs == theme.emojiSet.count {
                    Text("All of \(theme.emojis)")
                } else {
                    Text("\(String(theme.numberOfPairs)) pairs from \(theme.emojis)")
                }
            }
            .lineLimit(1)
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
    
    // MARK: Editing/Adding
    
    @State private var themeToEdit: Theme?
    
    private func tapToEditThemeItem(theme: Theme) -> some Gesture {
        TapGesture()
            .onEnded {
                themeToEdit = store.themes[theme]
            }
    }
    
    
    
    private var addThemeButton: some View {
        Button {
            store.insertTheme(named: "New")
            themeToEdit = store.themes.first
        } label: {
            Text("Add theme")
            Image(systemName: "plus.circle")
                .font(.system(size: 10))
        }
    }
    
}

struct ThemeManager_Previews: PreviewProvider {
    static var previews: some View {
        ThemeManager()
            .environmentObject(ThemeStore(named: "Preview"))
    }
}
