//
//  AppDelegate.swift
//  sdsdg
//
//  Created by ozr on 2022/12/2.
//

import UIKit
import OverseaHttpClient
import APMSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var serverDomain:ServerDomainProtocol?
    var httpdns:HTTPDNSProtocol?
    var socketProxy:SocketClientProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //网络库环境初始化，必须在didFinishLaunchingWithOptions开始时候添加，否则无法做hook
        NetworkManager.injectIntoAllNSURLSessionDelegateClasses()
        NetworkManager.shared.setup(OverseaHttpConfig(<#T##env: Environment##Environment#>))
        
        //apm环境初始化，必须在didFinishLaunchingWithOptions开始时候添加，否则无法做hook
        Apm.shared.preStart(for: <#T##MonitorEnvironment#>)
        
        //在适当时候启动apm
        let apmConfig = APMSwift.Config(appName: <#T##String#>, clientVersion: <#T##String#>, smid: <#T##String#>)
        Apm.shared.start(with: apmConfig)
        
        //如需开启动态域名功能，在适当时候初始化，并更新配置，可参考owo
        let domainConfig = ServerDomainConfig(userId: <#T##Int#>, smid: <#T##String#>)
        serverDomain = NetworkManager.shared.createServerDomain(configuration: domainConfig)
        serverDomain?.getDomainInfo(completion: <#T##(Bool, Dictionary<String, Any>?) -> Void#>, updateDomain: <#T##(Dictionary<String, Any>?) -> Void#>)
        
        //如需开启httpdns功能，在适当时候初始化, 可参考owo
        httpdns = NetworkManager.shared.createHTTPDNS()
        httpdns?.start(with: <#T##Int#>)
        
        //如需开启长链接代理功能，在适当时候初始化, 可参考owo
        socketProxy = NetworkManager.shared.createSocketClient(<#T##bridge: SocketConnectBridge##SocketConnectBridge#>)
        socketProxy?.openSocketProxy(<#T##uid: Int##Int#>)
        
        //使用网络库请求get，post，upload请求
        NetworkManager.shared.POST(<#T##url: String##String#>, <#T##completion: (Int, String?, Any?) -> Void##(Int, String?, Any?) -> Void#>)
        
        //外网隔离
        var request = URLRequest(url: URL(string: "https://www.baidu.com")!)
        //隔离白名单可以找富银配置，如果想跳过配置，在头加标识
        request.setValue("1", forHTTPHeaderField: "Use-Isolate")
        let task = URLSession.shared.dataTask(with: request) { data, res, error in
            
        }
        task.resume()
        
        return true
    }


}

