//
//  ThemeEditor.swift
//  CS193p_Assignment6
//
//  Created by Jakub Łata on 05/01/2023.
//

import SwiftUI

struct ThemeEditor: View {
    
    //binding allows for editing some palette that is calling it, binding looks for location in the memory where the code is stored. @binding never equals to anything
    @Binding var theme: Theme
    @Environment(\.presentationMode) private var presentationMode
    
    init(theme: Binding<Theme>) {
        self._theme = theme
        self._chosenColor = State(initialValue: Color(rgbaColor: theme.wrappedValue.color))
    }
    
    var body: some View {
        Form {
            nameSection
            addEmojisSection
            removeEmojisSection
            numberOfPairsSection
            colorSection
        }
        .navigationTitle("\(theme.name)")
    }
    
    var nameSection: some View {
        Section(header: Text("Theme name")) {
            TextField("", text: $theme.name)
        }
    }
    
    @State private var emojisToAdd = ""
    
    var addEmojisSection: some View {
        Section(header: Text("Add emojis")) {
            TextField("", text: $emojisToAdd)
                //on change insert emojis to given theme
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        
        //convert set of emojis to string and then back to set
        var simpleStringOfEmojis = ""
        
        theme.emojiSet.forEach { simpleStringOfEmojis.append(String($0)) }
        
        simpleStringOfEmojis = (simpleStringOfEmojis + emojis)
            .filter{$0.isEmoji}
            .removingDuplicateCharacters
    
        theme.emojiSet = simpleStringOfEmojis.filter{$0.isEmoji}.removingDuplicateCharacters.map( { String($0) } )
    }
    
    var removeEmojisSection: some View {
        Section(header: Text("Remove emojis")) {
            let emojis = theme.emojiSet
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                if theme.emojiSet.count > theme.numberOfPairs {
                                    theme.emojiSet.removeAll(where: { String($0) == emoji })
                                }
                            }
                        }
                }
            }
        }
    }
    
    var numberOfPairsSection: some View {
        Section(header: Text("Number of card pairs")) {
            Stepper("\(theme.numberOfPairs) pairs", value: $theme.numberOfPairs, in: theme.emojiSet.count < 2 ? 0...0 : 2...theme.emojiSet.count)
        }
    }
    
    @State var chosenColor: Color = .red
    
    var colorSection: some View {
        Section(header: Text("Pick Color")) {
            ColorPicker("Color of the theme", selection: $chosenColor)
                .onChange(of: chosenColor) { newValue in
                    theme.color = RGBAColor(color: newValue)
                }
                .foregroundColor(Color(rgbaColor: theme.color))
        }
    }
    
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore(named: "Preview").theme(at: 0)))
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/350.0/*@END_MENU_TOKEN@*/))
    }
}
