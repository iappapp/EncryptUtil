//
//  ViewController.m
//  EncryptUtil
//
//  Created by tree on 2018/12/14.
//  Copyright © 2018年 tree. All rights reserved.
//

#import "ViewController.h"
#import "StringUtil.h"
#import "DBUtil.h"

@implementation ViewController
@synthesize typeMenuItem = _typeMenuItem;
@synthesize methodMenuItem = _methodMenuItem;
@synthesize queryButton = _queryButton;
@synthesize dataTextField = _dataTextFiled;
@synthesize resultTextView = _resultTextView;
@synthesize method = _method;
@synthesize type = _type;

- (void)viewDidLoad {
    [super viewDidLoad];
    _method = @"encrypt";
    _type = @"AES";
    NSColor* color = [NSColor colorWithSRGBRed:0 green:255 blue:0 alpha:255];
    [self.resultTextView setTextColor: color];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)encrypt_type:(id)sender {
    NSLog(@"start listener encrypt_type");
    NSMenuItem* selectedItem = [[NSMenuItem alloc] init];
    selectedItem = [sender selectedItem];
    NSString* menuTitle = [selectedItem title];
    NSLog(@"%@", menuTitle);
    if ([menuTitle isEqualToString:@"RSA"]) {
        _type = @"RSA";
    } else {
        _type = @"AES";
    }
    NSLog(@"type=%@", _type);
}

- (IBAction)encrypt_method:(id)sender {
    NSLog(@"start listener encrypt_type");
    NSMenuItem* selectedItem = [[NSMenuItem alloc] init];
    selectedItem = [sender selectedItem];
    NSString* menuTitle = [selectedItem title];
    NSLog(@"%@", menuTitle);
    if ([menuTitle isEqualToString:@"解密"]) {
        _method = @"decrypt";
    } else {
        _method = @"encrypt";
    }
    NSLog(@"method=%@", _method);
}


- (IBAction)button_query:(id)sender {
    NSAlert* alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    alert.messageText = @"HELLO WORLD";
    alert.icon = [[NSImage alloc] initWithContentsOfFile:@""];
    alert.informativeText = @"THIS IS MY MAC APP";
    NSLog(@"THIS IS MY APP");
    NSString* basicUrl = @"http://basisdata-others.test.treefintech.com/crypt?";
    if ([_dataTextFiled stringValue].length > 0) {
        basicUrl = [[basicUrl stringByAppendingString: @"type="] stringByAppendingString: _method];
        basicUrl = [[basicUrl stringByAppendingString: @"&data="] stringByAppendingString: [[_dataTextFiled stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        basicUrl = [basicUrl stringByReplacingOccurrencesOfString:@" " withString: @"%20"];
        basicUrl = [basicUrl stringByReplacingOccurrencesOfString:@"+" withString: @"%2B"];
        
    }
    NSLog(@"url=%@", basicUrl);
    NSURL* url = [NSURL URLWithString: basicUrl];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10000;
    NSURLSession* session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"URL Request error:%@", error);
            return;
        }
        
        NSError* jsonError = nil;
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error:&jsonError];
        NSString* jsonText = [NSString stringWithFormat:@"%@", dic];
        NSLog(@"response text=%@", [StringUtil handleSpaceAndEnterElementWithString: jsonText]);
        jsonText = [StringUtil replaceUnicode: jsonText];
        [self showResult: jsonText];
    }];
    DBUtil* dbUtil = [[DBUtil alloc] init];
    BOOL yes = [dbUtil openDBWithName: @""];
    NSLog(@"open SQLite db %@", yes ? @"succeed" : @"fail");
    [dbUtil isTableExist:@"t_record"];

    [dataTask resume];
}

- (void)showResult: (NSString*) result {
    // [_resultTextView setNeedsDisplay: true];
    [self performSelectorOnMainThread:@selector(showResultInMain:)
                        withObject: result
                        waitUntilDone:NO];
}

- (void)showResultInMain: (NSString*) result {
    result = [StringUtil handleSpaceAndEnterElementWithString: result];
    _resultTextView.string = result;
}

@end
