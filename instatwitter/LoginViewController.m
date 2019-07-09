//
//  LoginViewController.m
//  instatwitter
//
//  Created by frankboamps on 7/8/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (IBAction)loginUser:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
        }
    }];
}

//-(void) registerUser{
//    PFUser *newUser = [PFUser user];
//    newUser.username = self.usernameField.text;
//    //newUser.email = self.emailField.text;
//    newUser.password = self.passwordField.text;
//    
//    // call sign up function on the object
//    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
//        if (error != nil) {
//            NSLog(@"Error: %@", error.localizedDescription);
//        } else {
//            NSLog(@"User registered successfully");
//            
//            // manually segue to logged in view
//        }
//    }];
//}

//- (void)loginUser {
//    NSString *username = self.usernameField.text;
//    NSString *password = self.passwordField.text;
//
//    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
//        if (error != nil) {
//            NSLog(@"User log in failed: %@", error.localizedDescription);
//        } else {
//            NSLog(@"User logged in successfully");
//
//            // display view controller that needs to shown after successful login
//        }
//    }];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
