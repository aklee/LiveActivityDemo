//
//  LiveActivityUtils.swift
//  LiveActivityDemo
//
//  Created by ak on 2022/11/15.
//

import Foundation
import ActivityKit
import MyWidgetExtension

class LiveActivityUtils {
    static func request() async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("no AuthorizationInfo")
            //监听开关状态
            for await enablment in ActivityAuthorizationInfo().activityEnablementUpdates {
                print("Activity AuthorizationInfo change to \(enablment)")
            }
            return
        }
        
        end()
        
        let state = MyWidgetAttributes.ContentState(prograssState: .Car)
        let attri = MyWidgetAttributes(name: "AK Lee")
        do {
            
            let current = try Activity.request(attributes: attri, contentState: state, pushType: .token)
            Task {
                for await tokenData in current.pushTokenUpdates {
                    let mytoken = tokenData.map { String(format: "%02x", $0) }.joined()
                    print("activity push token", mytoken)
                }
            }
            Task {
                for await state in current.contentStateUpdates {
                    print("content state update: tip=\(state.prograssState)")
                }
            }
            Task {
                for await state in current.activityStateUpdates {
                    print("activity state update: tip=\(state) id:\(current.id)")
                }
            }
            print("request success,id:\(String(describing: current.id))");
        } catch(let error) {
            print("error=",error)
        }
    }
    
    static func update(_ state: PrograssState) {
        Task {
            guard let current = Activity<MyWidgetAttributes>.activities.first else {
                return
            }
            print("local update");
            let state = MyWidgetAttributes.ContentState(prograssState: state)
            let alertConfiguration = AlertConfiguration(title: "Delivery Update ", body: "Delivery Update State to \(state.prograssState.desc())", sound: .default)
            //update with alert
            await current.update(using: state, alertConfiguration: alertConfiguration)
            
            //update with no alert
//            await current.update(using: state, alertConfiguration: nil)
        }
    }
    
    static func end() {
        for act in Activity<MyWidgetAttributes>.activities {
            print("id:\(act.id) state:\(act.activityState)")
        }
        let activities = Activity<MyWidgetAttributes>.activities.filter { act in
            return act.activityState == .active
        }
        guard activities.count > 0 else { return }
        for item in activities {
            Task {
                print("end activity \(item.id)")
                //let state = MyWidgetAttributes.ContentState(prograss: 1, tip: "Bye Bye~")
                await item.end(dismissalPolicy:.immediate)
            }
        }
    }
}

