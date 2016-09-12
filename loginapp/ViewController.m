//
//  ViewController.m
//  loginapp
//
//  Created by Mihaela Pacalau on 8/24/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"user", nil]
                                                  forKeys:[NSArray arrayWithObjects:@"user", nil]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Bar

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - Actions

- (IBAction)logInButton:(UIButton *)sender {
    
   
    if ([[loginDictionary objectForKey: self.passwordField.text] isEqualToString:self.usernameField.text]) {
        NSLog(@"Succes");
    } else {
        NSLog(@"Unsucces");
        NSLog(@"%@", self.usernameField.text);
        NSLog(@"%@", self.passwordField.text);
        
        UIAlertController* loginErrorAlertController = [UIAlertController alertControllerWithTitle:@"Error Signing In"
                                                                                 message:@"The user name or password is incorrect"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* loginErrorAlertAction = [UIAlertAction actionWithTitle:@"OK"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction* _Nonnull action) {
                                                                      }];
        
        [loginErrorAlertController addAction:loginErrorAlertAction];
        [self presentViewController:loginErrorAlertController animated:YES completion:nil];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
