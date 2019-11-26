//
//  WebViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 04.07.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import AlamofireObjectMapper

final class VKWebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    @IBAction func logout(unwindSegue: UIStoryboardSegue) {
        logoutVK()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        logoutVK()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7043782"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends, groups, photos, wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        if let token = params["access_token"],
           let userID = params["user_id"] {
//                print(token)
                Session.instance.token = token
                Session.instance.userId = Int(userID)!
        }
        
        
//        // сохраняем токен в Keychain
//        KeychainWrapper.standard.set(Session.instance.token, forKey: "token")
//        //print(KeychainWrapper.standard.string(forKey: "token") as Any)
//
//        // сохраняем версию в UserDefaults
//        let userDefaults = UserDefaults.standard
//        userDefaults.set("5.68", forKey: "version")
//        //print(userDefaults.string(forKey: "version") as Any)
        
        // переход на TabBarController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        present(vc, animated: true, completion: nil)
        
        decisionHandler(.cancel)
    }
    
    private func logoutVK() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(
                ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                for: records.filter { $0.displayName.contains("vk")},
                completionHandler: { }
            )
        }
    }
}
