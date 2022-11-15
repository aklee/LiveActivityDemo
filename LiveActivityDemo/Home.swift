//
//  Home.swift
//  LiveActivityDemo
//
//  Created by ak on 2022/11/15.
//

import SwiftUI

struct Home: View {
   @State var state: PrograssState = .Car
    var body: some View {
        VStack {
            VStack {
                HStack {
                    HStack {
                        MyViews.CirclrIcon("person.and.background.dotted", color: .blue)
                            .frame(width: 50, height: 50)
//                        Image("dog")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 50, height: 50)
//                            .clipShape(Circle())
                            
                        
                        Text("AK Lee")
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
                            .background(.black.opacity(0.1))
                            .background(in: Capsule())
                            .padding(.leading, 32)
                            .padding(.trailing, 32)
                        
                        HStack {
                            ForEach ([PrograssState.Car,
                                      .Storehouse,
                                      .Package,
                                      .Arrived], id:\.self) { state in
                                          let choose = self.state == state
                                          MyViews.CirclrIcon(state.image(), color:choose ? .cyan : .green)
                                              .frame(width: 60, height: choose ? 40 : 30)
                                          
                                      }
                        }
                        
                    }
                }
                .padding(.top, 8)
                
            }
            .frame(width: 350, height: 140)
            .padding(.leading,10)
            .padding(.trailing,10)
            .background(Color.green)
            .cornerRadius(20)
            
            VStack(spacing: 15) {
                Button("add Activity") {
                    Task {
                        await LiveActivityUtils.request()
                    }
                }
                
                Button("update Activity") {
                    self.state = PrograssState(rawValue: (state.rawValue + 1) % 4) ??  .Car
                    LiveActivityUtils.update(self.state)
                }
                
                Button("end Activity") {
                    LiveActivityUtils.end()
                }
                
            }
        }.onAppear {
            Task {
                print("add Activity")
                await LiveActivityUtils.request()
            }
        }
    }
    
    func logMsg(_ str: String) {
        print(str)
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
