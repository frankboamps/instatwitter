//
//  InataPostTableViewCell.h
//  instatwitter
//
//  Created by frankboamps on 7/9/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface InataPostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postUserImage;
@property (weak, nonatomic) IBOutlet UILabel *postUserName;
@property (weak, nonatomic) IBOutlet UIImageView *feedPostImageView;
@property (weak, nonatomic) IBOutlet UILabel *feedCaptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *postFavoriteCount;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *postCommentCount;

@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
