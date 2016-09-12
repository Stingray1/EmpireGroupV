//
//  ViewController.h
//  loginapp
//
//  Created by Mihaela Pacalau on 8/24/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    
    NSString* usernameString;
    NSString* passwordString;
    NSDictionary* loginDictionary;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)logInButton:(UIButton *)sender;

@end

