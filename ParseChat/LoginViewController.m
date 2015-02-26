//
//  LoginViewController.m
//  ParseChat
//
//  Created by Neal Wu on 2/25/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "ChatViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextField.secureTextEntry = YES;
    self.emailTextField.text = @"neal@nealwu.com";
    self.passwordTextField.text = @"password";
}

- (IBAction)onSignIn:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSLog(@"Attempting to sign in with email %@ and password %@", email, password);

    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"Login succeeded! %@", user);
            [self presentViewController:[[ChatViewController alloc] init] animated:YES completion:nil];
        } else {
            NSLog(@"Login failed: %@", error);
        }
    }];
}

- (IBAction)onSignUp:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;

    PFUser *user = [PFUser user];
    user.username = email;
    user.password = password;
    user.email = email;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"Hooray! Sign up worked");
            [self presentViewController:[[ChatViewController alloc] init] animated:YES completion:nil];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            // Show the errorString somewhere and let the user try again.
        }
    }];
}

@end
