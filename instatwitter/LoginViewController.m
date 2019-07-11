//
//  LoginViewController.m
//  instatwitter
//
//  Created by frankboamps on 7/8/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SignUpViewController.h"
#import "HomeFeedViewController.h"

@interface LoginViewController () <SignUpViewController>

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginUser:(id)sender
{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"navigationToHomeFeed" sender:nil];
        }
    }];
}
- (IBAction)tapGestureToMakeKeyboardDisappear:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SignUpViewController *signUpViewController = [segue destinationViewController];
    signUpViewController.delegate = self;
}


- (void)signUpViewControllerDidFinish:(nonnull SignUpViewController *)signUpViewController
{
    
}



@end
