//
//  ViewController.h
//  EncryptUtil
//
//  Created by tree on 2018/12/14.
//  Copyright © 2018年 tree. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (nonatomic, retain) IBOutlet NSMenuItem* typeMenuItem;
@property (nonatomic, retain) IBOutlet NSMenuItem* methodMenuItem;
@property (weak) IBOutlet NSTextField *dataTextField;
@property (weak) IBOutlet NSButton *queryButton;
@property (strong,nonatomic) IBOutlet NSTextView *resultTextView;
@property NSString* method;
@property NSString* type;

// button listener
- (IBAction)button_query:(id)sender;

// selector listener
- (IBAction)encrypt_type:(id)sender;

// encrypt or decrypt
- (IBAction)encrypt_method:(id)sender;

@end

