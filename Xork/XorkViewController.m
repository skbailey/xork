//
//  ViewController.m
//  Xork
//
//  Created by Pietro Rea on 8/4/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "XorkViewController.h"
#import "ConsoleTextView.h"

@import JavaScriptCore;

@interface XorkViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ConsoleTextView *outputTextView;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) JSContext *context;

@end

@implementation XorkViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.inputTextField.delegate = self;
    [self.inputTextField becomeFirstResponder];
    
    UIFont *navBarFont = [UIFont fontWithName:@"Courier" size:23];
    NSDictionary *attributes = @{NSFontAttributeName : navBarFont};
    [self.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"hello" ofType:@"js"];
    NSString *scriptString = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:nil];
    
    self.context = [[JSContext alloc] init];
    [self.context evaluateScript:scriptString];
    
    __weak XorkViewController *weakself = self;
    self.context[@"print"] = ^(NSString *text) {
        text = [NSString stringWithFormat:@"%@\n", text];
        [weakself.outputTextView setText:text concatenate:YES];
    };
    
    JSValue *function = self.context[@"startGame"];
    [function callWithArguments:@[]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *inputString = textField.text;
    [inputString lowercaseString];
    
    if ([inputString isEqualToString:@"clear"]) {
        [self.outputTextView clear];
    } else {
        [self.outputTextView setText:inputString concatenate:YES];
    }
    
    [self.inputTextField setText:@""];
    
    return YES;
}



@end
