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

#pragma mark - Viewcontroller LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Setting Login authentication

- (IBAction)loginUser:(id)sender
{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid Information"
                                                                           message:[NSString stringWithFormat:@"%@", error.localizedDescription]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:^{}];
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"navigationToHomeFeed" sender:nil];
        }
    }];
}

#pragma mark - Setting Tap Gesture

- (IBAction)tapGestureToMakeKeyboardDisappear:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SignUpViewController *signUpViewController = [segue destinationViewController];
    signUpViewController.delegate = self;
}

#pragma mark - Conforming to SignupView controller delegate

- (void)signUpViewControllerDidFinish:(nonnull SignUpViewController *)signUpViewController
{
    
}


@end
