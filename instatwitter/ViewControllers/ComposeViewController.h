//
//  ComposeViewController.h
//  instatwitter
//
//  Created by frankboamps on 7/8/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@protocol ComposeViewControllerDelegate
- (void)didPost;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *postTextField;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
