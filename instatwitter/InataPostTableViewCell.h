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

//@protocol InstaCellDelegate
//- (void)instaCell:(InataPostTableViewCell *) instaCell didTap: (User *)user;
//@end

@interface InataPostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postUserImage;
@property (weak, nonatomic) IBOutlet UILabel *postUserName;

@property (weak, nonatomic) IBOutlet UIImageView *feedPostImageView;
@property (weak, nonatomic) IBOutlet UILabel *feedCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *postFavoriteCount;
@property (weak, nonatomic) IBOutlet UILabel *postCommentCount;

//@property (nonatomic, weak) id<InstaCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
