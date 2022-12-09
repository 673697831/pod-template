//
//  String+AES.swift
//  DESTool
//
//  Created by ron on 2022/5/5.
//

import Foundation



extension String{
    static let aes_iv = "asdfghjklzxcvbnm"
    static let aes_key = "stoly__niubility"
    
    static let aes_iv_http = "KDCNSDLEDKDDLDCK"
    static let aes_key_http = "KDCNSDLEDKDDLDCK"
    
    func aesEncryptString() -> String{
        let aes = AES.init(key: String.aes_key, iv_: String.aes_iv);
        if let d = aes?.encrypt(string: self){
            return d.base64EncodedString()
        }
        return "";
    }
    
    /**
     基础业务，http请求解密
     */
    func httpDString()->String{
         
        let aes = AES.init(key: String.aes_key_http, iv_: String.aes_iv_http);
        
        if let data = Data.init(base64Encoded: self){
            
            if let dStr = aes?.decrypt(data: data){
                return dStr
            }
            return ""
        }
        return "";
    }
    
    /**
     基础业务，http请求加密
     */
    func httpEString() -> String{
        
        let aes = AES.init(key: String.aes_key_http , iv_: String.aes_iv_http);
        if let d = aes?.encrypt(string: self){
            return d.base64EncodedString()
        }
        return "";
    }
    
    /**
     解密字符串，如果解密失败，返回原来的字符串
     */
    func dString()->String{
        
        //过滤服务器api接口
        if(self.contains("/api/")){
            return self
        }
        
        let aes = AES.init(key: String.aes_key, iv_: String.aes_iv);
        
        if let data = Data.init(base64Encoded: self){
            
            if let dStr = aes?.decrypt(data: data){
                return dStr
            }
            return ""
        }
        return self;
    }
}
