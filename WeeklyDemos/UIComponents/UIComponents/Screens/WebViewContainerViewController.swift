//
//  WebViewContainerViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import WebKit

class WebViewContainerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var randomFontButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureWebView()
        configureActivityIndicator()
    }

    var urlString = "https://www.google.com"
    
    var isHtmlOpened = false
    var htmlString = "<html><body><p>Hello!</p></body></html>"
    var newHtmlString = ""
    
    func configureWebView() {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)

        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
//        webView.configuration = configuration
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.isLoading),
                            options: .new,
                            context: nil)
        webView.load(urlRequest)
    }

    func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.color = .red
        activityIndicator.hidesWhenStopped = true
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        if keyPath == "loading" {
            webView.isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

//MARK: Bar Button Item IBAction Functions
    
    @IBAction func reloadButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        if webView.canGoBack{
            webView.goBack()
        } else if isHtmlOpened{
            isHtmlOpened = false
            randomFontButton.isEnabled = false
            guard let url = URL(string: urlString) else { return }
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
    @IBAction func openInSafariButtonTapped(_ sender: UIBarButtonItem) {
        if let url = webView.url {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIBarButtonItem) {
        if webView.canGoForward{
            webView.goForward()
        }
    }
    
//MARK: Opening String html and Changing Font
    
    @IBAction func openHtmlButtonTapped(_ sender: UIBarButtonItem) {
        webView.loadHTMLString(htmlString, baseURL: nil)
        isHtmlOpened = true
        randomFontButton.isEnabled = true
        
    }
    
  
    @IBAction func randomFontButtonTapped(_ sender: UIBarButtonItem) {
        newHtmlString = newHtmlString(old: htmlString)
        webView.loadHTMLString(newHtmlString, baseURL: nil)
        
    }
    
    func newHtmlString(old: String) -> String{
        let font = UIFont.familyNames.randomElement()!
        var fontHtml = ""
        if old.contains("<p>"){
           fontHtml = old.replacingOccurrences(of: "<p>", with: "<p style='font-family: \(font); font-size: 50px'>")
        }
        return fontHtml
    }
    
}

extension WebViewContainerViewController: WKNavigationDelegate {

}

extension WebViewContainerViewController: WKUIDelegate {

}
