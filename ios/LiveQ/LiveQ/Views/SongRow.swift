//
//  SongRow.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import SwiftUI

struct SongRow: View {
    
    var song: Song
    
    var body: some View {
        HStack {
            ImageView(withURL: song.imageUri)
            
            VStack(alignment: .leading) {
                Text(song.name)
                Text(Song.getArtistString(song: song))
            }
            
            Spacer()
            Text(song.getDurationString())
        }
    }
}

struct SongRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SongRow(song: QueueViewModel().songs[0])
            SongRow(song: QueueViewModel().songs[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
