//
//  SignUpViewController.h
//  instatwitter
//
//  Created by frankboamps on 7/8/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *signupEmailField;
@property (weak, nonatomic) IBOutlet UITextField *signupUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *signupPasswordField;

@end

NS_ASSUME_NONNULL_END
