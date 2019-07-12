//
//  InstaCollectionCell.h
//  instatwitter
//
//  Created by frankboamps on 7/11/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstaCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postedImage;
@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
