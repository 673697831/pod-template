//
//  AppDelegate.swift
//  Demo
//
//  Created by ozr on 2022/12/8.
//

import UIKit
import APMSwift
import OverseaHttpClient

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var serverDomain:ServerDomainProtocol?
    var httpdns:HTTPDNSProtocol?
    var socketProxy:SocketClientProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NetworkManager.injectIntoAllNSURLSessionDelegateClasses()
        NetworkManager.shared.setup(OverseaHttpConfig(.test))
        Apm.shared.preStart(for: .test, openDebug: true)
        
        //程序初始化后，启动apm，动态域名和dns
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.loadDomianInfo()
        }
        
        return true
    }
    
    func loadDomianInfo() {
        //如需开启动态域名功能，在适当时候初始化，并更新配置，可参考owo
        let domainConfig = ServerDomainConfig(userId: 0, smid: "")
        serverDomain = NetworkManager.shared.createServerDomain(configuration: domainConfig)
        serverDomain?.getDomainInfo(completion: { result, dic in
            if result {
                //根据业务具体情况而定，继续初始化其他功能
                self.startHttpdns()
                self.startApm()
            }
        }, updateDomain: { dic in
            
        })
    }
    
    func startHttpdns() {
        //如需开启httpdns功能，在适当时候初始化, 可参考owo
        httpdns = NetworkManager.shared.createHTTPDNS()
        httpdns?.start(with: 0)
    }
    
    func startApm() {
        //在适当时候启动apm, 此处用到owo配置
        let apmConfig = APMSwift.Config(appName: "owonovel", clientVersion: "OWONOVEL2.2.0_Iphone", smid: "")
        Apm.shared.start(with: apmConfig)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

