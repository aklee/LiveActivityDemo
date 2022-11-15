//
//  MyWidgetBundle.swift
//  MyWidget
//
//  Created by ak on 2022/11/15.
//

import WidgetKit
import SwiftUI

@main
struct MyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyWidget()
        MyWidgetLiveActivity()
    }
}
