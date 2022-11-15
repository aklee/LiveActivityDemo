iOS16.1开始允许开发者和灵动岛交互。引入新概念Live Activity 实时活动，我们简称LA。

<h2>首先说限制：</h2>
* LA无法访问网络、接收定位信息， 如果要更新数据，需要通过app的ActivityKit.framework 或者 接收远程推送APNs。 </br>
* 数据通信的大小限制，不论是本地数据还是APNs是数据，给到LA的数据都不能超过4KB</br>
* 启动灵动岛Live Activity可能会失败，因为设备有启动灵动岛的个数限制</br>
* 用户不能主动设置视图动画，系统会帮你做过渡动画</br>
* 除非App或用户结束LA，否则最多可以活跃8个小时。 超过8小时，系统自动结束。当LA结束时候，系统会立即将其从灵动岛中移除。  </br>
但是，LA会保留在锁定屏幕上，直到用户将其删除或在系统将其删除之前再保留最多四个小时——以先到者为准。 因此，实时活动会在锁定屏幕上保留最多 12 小时。</br>




<h2>授权开关：</h2>
areActivitiesEnabled : LA是否可用
activityEnablementUpdates：用于监听LA可用状态改变

<h2>交互规则：</h2>
App只能在前台启动LA。 在前后台都可以更新 或 中止LA。
遵循用时打开，不用就关闭的原则。App退出后，如果LA还没退出可能导致crash。


<h2>开发者如何添加Live Activity</h2>
1 Info.plist 增加 Key为NSSupportsLiveActivities， Value为YES</br>
2 创建tareget widget</br>
3 开始自定义交互的UI</br>
4 在App中进行LA的启动、更新、终止</br>


<h2>Live Activity交互UI规则</h2>

```swift
//定义模型特征
public struct MyWidgetAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        // 可变特征，可以在App内或者APNs中更新属性，系统自动刷新视图
        public var prograssState: PrograssState
    }
    
    // Fixed non-changing properties about your activity go here!
    // 固定特征，在初始化Live Activity时指定，后续更新视图也不再变化
    public var name: String
}

@main
struct MyWidgetLiveActivity: Widget {

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MyWidgetAttributes.self) { context in
            // 启动LiveActivity后，锁屏页 或者 通知栏页中 将展示实时活动视图
            // 锁屏下，不支持灵动岛视图。但会通知栏页常驻
            // 参考图1
        } dynamicIsland: { context in
            DynamicIsland {
                // Dynamic Island Expanded view
                // 灵动岛长按展开后的视图
                // 参考图2

                DynamicIslandExpandedRegion(.leading) {
                    //leading位置的视图设置
                }
                 DynamicIslandExpandedRegion(.trailing) {
                    //trailing位置的视图设置
                }
                DynamicIslandExpandedRegion(.center) {
                    //center位置的视图设置
                }
                DynamicIslandExpandedRegion(.bottom) {
                    //bottom位置的视图设置
                }

            } compactLeading: {
                // Dynamic Island compact leading view
                // 灵动岛未展开时，leading位置的视图设置
                // 参考图3
            } compactTrailing: {
                // Dynamic Island compact trailing view
                // 灵动岛未展开时，trailing位置的视图设置
                // 参考图3
            } minimal: {
                // Dynamic Island minimal view
                // 当有多个Live Activity时， 
                // 系统将选择其中一个Live Activity作为最小化的视图展示
                // 参考图4
            }
        }
    }
}

```
长按灵动岛将展开如下，可以分别根据不同位置设置视图。
如果Bottom区域不设置视图，Leading、Trailing、Center可以向下占据空间。

<img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cb9b3fe5193f42159173d323f9c0b4d9~tplv-k3u1fbpfcp-watermark.image?" alt="2CA041F8-B58D-4B19-B49E-032CC4A54CC8.png" width="60%" />



参考图1：启动LiveActivity后，锁屏页 或者 通知栏页中 将展示实时活动视图

<img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d4d928b0c7ed4923bf4bf65e41a2f983~tplv-k3u1fbpfcp-watermark.image?" alt="1668491632240.jpg" width="50%" />

用户可以侧滑删除，来关闭通知中心页的Live Activity实时活动视图，同时也会关闭灵动岛上的视图

<img src="https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/86633e0063cf479e8303c70d5cb542d4~tplv-k3u1fbpfcp-watermark.image?" alt="截屏2022-11-15 13.57.10.png" width="50%" />


参考图2：灵动岛长按展开后的视图

<img src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/87c0bafca4e84053abde4ddcd4d64c4a~tplv-k3u1fbpfcp-watermark.image?" alt="IMG_0017.PNG" width="50%" />


参考图3：灵动岛未展开时，leading和trailing的视图设置
<img src="https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b5a763ebbc004c56bbdcd382f857fb2f~tplv-k3u1fbpfcp-watermark.image?" alt="截屏2022-11-11 10.54.14.png" width="50%" />



参考图4:
当有多个Live Activity时， 系统将选择其中一个Live Activity作为最小化的视图展示

<img src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cd4a6e9600564f709da8f1847cabd545~tplv-k3u1fbpfcp-watermark.image?" alt="截屏2022-11-15 13.51.42.png" width="50%" />

<h2>Live Activity的启动、更新、终止</h2>

启动实时活动
```swift
let current = try Activity.request(attributes: attri, contentState: state, pushType: .token)

//监听Activity的回调
Task {
    //监听Token变化
    for await tokenData in current.pushTokenUpdates {
        let mytoken = tokenData.map { String(format: "%02x", $0) }.joined()
        print("activity push token", mytoken)
    }
}
Task {
    //监听state状态变化， 状态变化：active，end，dismissed等
    for await state in current.contentStateUpdates {
        print("content state update: tip=\(state.prograssState)")
    }
}
Task {
    //监听视图的声明周期，
    for await state in current.activityStateUpdates {
        print("activity state update: tip=\(state) id:\(current.id)")
    }
}

```
更新实时活动
```swift
//构造数据模型
let state = MyWidgetAttributes.ContentState(prograssState: state)

let alertConfiguration = AlertConfiguration(title: "Delivery Update ", body: "Delivery Update State to \(state.prograssState.desc())", sound: .default)

//更新实时活动视图内容，同时发起一条本地通知
await current.update(using: state, alertConfiguration: alertConfiguration)

//或者 仅更新实时活动视图内容
await current.update(using: state, alertConfiguration: nil)
```



<h2>APNs推送</h2>
LA推送生命周期：</br>
app进入前台，发起LA业务，采集LA token，上传我们的服务器后进行推送。 
App或用户结束LA时，token失效。</br>


apns请求头：</br>
apns-push-type: liveactivity</br>
apns-topic: <your bundleID>.push-type.liveactivity</br>
apns请求体增加字段content-state, 会序列化到Live Activity中的state并更新视图</br>
**注意**： timestamp必须是当前时间戳，否则会推送失败</br>

apns请求体样例：</br>
```
{
    "aps": {
        "timestamp": 1168364460,
        "event": "update",
        "content-state": {
            "driverName": "Anne Johnson",
            "estimatedDeliveryTime": 1659416400
        },
        "alert": {
            "title": "Delivery Update",
            "body": "Your pizza order will arrive soon.",
            "sound": "example.aiff" 
        }
    }
}

```
设备收到APNs通知后，灵动岛会自动展开、渲染视图、动画，然后关闭。 视频如下：



Github Demo:

https://github.com/aklee/LiveActivityDemo/edit/main/README.md

 
