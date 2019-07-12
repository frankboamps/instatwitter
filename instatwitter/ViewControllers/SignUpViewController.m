//
//  SignUpViewController.m
//  instatwitter
//
//  Created by frankboamps on 7/8/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -Resgistering user

- (IBAction)registerUser:(id)sender
{
    PFUser *newUser = [PFUser user];
    newUser.username = self.signupUsernameField.text;
    newUser.email = self.signupEmailField.text;
    newUser.password = self.signupPasswordField.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid Information"
                                                                           message:[NSString stringWithFormat:@"%@", error.localizedDescription]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:^{}];
            
        } else {
            NSLog(@"User registered successfully");
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate signUpViewControllerDidFinish:self];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - Setting back button

- (IBAction)didTapBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
