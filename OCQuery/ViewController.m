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
    //    context[@"html"] = html;
    JSValue *loadHTML = context[@"loadHTML"];
    [loadHTML callWithArguments:@[html]];
    JSValue *queryWithCss = context[@"queryWithCss"];
    JSValue *value = [queryWithCss callWithArguments:@[@".sqv-item .sqv-hd"]];
    for (NSDictionary *dict in [value toArray]) {
        NSLog(@"%@",[dict valueForKey:@"text" ]);
    }
    
    NSLog(@"OK");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
