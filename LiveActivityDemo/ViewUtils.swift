//
//  ViewUtils.swift
//  LiveActivityDemo
//
//  Created by ak on 2022/11/15.
//

import Foundation
import SwiftUI

class MyViews {
    @ViewBuilder
    static func CirclrIcon(_ name: String, color: Color = .red) -> some View {
        Circle()
            .foregroundColor(color)
            .overlay {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .padding(5)
                    .bold()
            }
    }
}

