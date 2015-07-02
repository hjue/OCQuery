//
//  ViewController.m
//  OCQuery
//
//  Created by hjue on 7/1/15.
//  Copyright (c) 2015 hjue. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)test {

    NSError *error;
    JSContext *context = [[JSContext alloc] init];
    

    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"error:%@", value);
    }];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"app" ofType:@"js"];
    NSString *appjs = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSString * jsCode = [NSString stringWithFormat:@"%@ %@",@"var window = this; ",appjs];
    [context evaluateScript:jsCode];
    
    
    NSString *html_path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:html_path encoding:NSUTF8StringEncoding error:&error];
    JSValue *loadHTML = [context objectForKeyedSubscript:@"loadHTML"];
    [loadHTML callWithArguments:@[html]];
    JSValue *queryWithCss = [context objectForKeyedSubscript:@"queryWithCss"];
    JSValue *value = [queryWithCss callWithArguments:@[@".sqv-item .sqv-hd"]];
    for (NSDictionary *dict in [value toArray]) {
        NSLog(@"%@",[dict valueForKey:@"val" ]);
    }
    
    value = [queryWithCss callWithArguments:@[@".sqv-item",@{@"url":@"a",@"img":@"img"}]];
    for (NSDictionary *dict in [value toArray]) {
        NSLog(@"%@",[dict valueForKey:@"url" ]);
    }
    
    NSLog(@"OK");
    
    NSURL *url = [NSURL URLWithString:@"http://weixin.sogou.com/weixinwap?query=stuq&fr=sgsearch&type=1"];
    html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    [loadHTML callWithArguments:@[html]];
    value = [queryWithCss callWithArguments:@[@".account_box_lst .account_box",
             @{
    @"name":@".lst_wechat_txt",
    @"desc":@".lst_wechat_txt2",
    @"image":@".account_thumb img",
    @"no" : @".lst_wechat_txt:contains('gh_')"
               }]];
    for (NSDictionary *dict in [value toArray]) {
        NSLog(@"%@,%@",[dict valueForKey:@"name" ],[dict valueForKey:@"desc" ]);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
