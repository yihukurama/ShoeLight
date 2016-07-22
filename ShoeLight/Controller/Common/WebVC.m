//
//  WebVC.m
//  NewGS
//
//  Created by newgs_mac on 15/1/20.
//  Copyright (c) 2015年 cnmobi. All rights reserved.
//

#import "WebVC.h"

@interface WebVC () <UIWebViewDelegate,UIActionSheetDelegate>
{
    NSString *_title;
    NSString *_urlString;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


@end

@implementation WebVC

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _title;
    self.webView.delegate = self;
    [self loadData];
}



- (void)loadData
{
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.indicator startAnimating];
}


#pragma mark - Public

- (void)configureWithUrl:(NSString *)urlString title:(NSString *)title
{
    _title = title;
    
    if ([[urlString lowercaseString] hasPrefix:@"http://"]) {
        _urlString = urlString;
    } else {
        _urlString = [NSString stringWithFormat:@"http://%@",urlString];
    }
}



#pragma mark - WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicator stopAnimating];

}


@end
