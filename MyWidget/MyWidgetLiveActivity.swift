//
//  MyWidgetLiveActivity.swift
//  MyWidget
//
//  Created by ak on 2022/11/11.
//

import ActivityKit
import WidgetKit
import SwiftUI

public enum PrograssState: Int, Codable, Hashable {
    case Car = 0
    case Storehouse
    case Package
    case Arrived
    
    func image() -> String {
        switch self {
        case .Car:
            return "box.truck"
        case .Storehouse:
            return "house"
        case .Package:
            return "shippingbox"
        case .Arrived:
            return "flag.checkered"
        }
    }
    
    func desc() -> String {
        switch self {
        case .Car:
            return "In Car"
        case .Storehouse:
            return "In Storehouse"
        case .Package:
            return "Is Packageing"
        case .Arrived:
            return "Is Arrived"
        }
    }
    
}

public struct MyWidgetAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        public var prograssState: PrograssState
    }
    
    // Fixed non-changing properties about your activity go here!
    public var name: String
}

struct MyWidgetLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MyWidgetAttributes.self) { context in
            // 在锁屏页 或者 通知列表页中展示。
            lockView(context)
                .activityBackgroundTint(Color.cyan)
                .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        MyViews.CirclrIcon("person.and.background.dotted", color: .blue)
                            .frame(width: 44, height: 44)
                        
                        Text(context.attributes.name)
                            .font(.subheadline)
                            .bold()
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        MyViews.CirclrIcon("carrot", color: .blue)
                            .frame(width: 30, height: 30)
                            .padding(.leading, -15)
                        
                        MyViews.CirclrIcon("birthday.cake", color: .purple)
                            .frame(width: 30, height: 30)
                            .padding(.leading, -15)
                        
                        MyViews.CirclrIcon("cup.and.saucer", color: .orange)
                            .frame(width: 30, height: 30)
                            .padding(.leading, -15)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    ZStack {
                        Divider()
                            .frame(height: 2)
                            .background(.black.opacity(0.5))
                            .background(in: Capsule())
                            .padding(.leading, 22)
                            .padding(.trailing, 22)
                        
                        HStack {
                            ForEach ([PrograssState.Car,
                                      .Storehouse,
                                      .Package,
                                      .Arrived], id:\.self) { state in
                                          let choose = context.state.prograssState == state
                                          MyViews.CirclrIcon(state.image(), color:choose ? .green : .cyan)
                                              .frame(width: 60, height: choose ? 40 : 30)
                                          
                                      }
                        }
                    }
                }
                
            } compactLeading: {
                Text("个推")
                    .font(.footnote)
                    .foregroundColor(.green)
            } compactTrailing: {
                Image(systemName:context.state.prograssState.image())
                
            } minimal: {
                Image(systemName:context.state.prograssState.image())
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(.red)
        }
    }
    
    @ViewBuilder
    func lockView(_ context: (ActivityViewContext<MyWidgetAttributes>)) -> some View {
        VStack {
            HStack {
                HStack {
                    MyViews.CirclrIcon("person.and.background.dotted", color: .blue)
                        .frame(width: 44, height: 44)
                    
                    Text(context.attributes.name)
                        .font(.subheadline)
                        .bold()
                    
                }
                .padding(.leading, 5)
                
                Spacer()
                HStack {
                    MyViews.CirclrIcon("carrot", color: .blue)
                        .frame(width: 30, height: 30)
                        .padding(.leading, -15)
                    
                    MyViews.CirclrIcon("birthday.cake", color: .purple)
                        .frame(width: 30, height: 30)
                        .padding(.leading, -15)
                    
                    MyViews.CirclrIcon("cup.and.saucer", color: .orange)
                        .frame(width: 30, height: 30)
                        .padding(.leading, -15)
                    
                }
            }
            
            HStack {
                ZStack {
                    Divider()
                        .frame(height: 2)
                        .background(.black.opacity(0.5))
                        .background(in: Capsule())
                        .padding(.leading, 22)
                        .padding(.trailing, 22)
                    
                    HStack {
                        ForEach ([PrograssState.Car,
                                  .Storehouse,
                                  .Package,
                                  .Arrived], id:\.self) { state in
                                      let choose = context.state.prograssState == state
                                      MyViews.CirclrIcon(state.image(), color:choose ? .green : .cyan)
                                          .frame(width: 60, height: choose ? 40 : 30)
                                      
                                  }
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(10)
        .frame(height: 120)
    }
    
}

