//
//  InataPostTableViewCell.m
//  instatwitter
//
//  Created by frankboamps on 7/9/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "InataPostTableViewCell.h"

@implementation InataPostTableViewCell

#pragma mark - Cell LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - Setting up Animations

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Setting Tap button

- (IBAction)didTapLike:(id)sender
{
    NSLog(@"Original Array%@", self.post.usersWhoLiked);
    if (![self.post.usersWhoLiked containsObject:[PFUser currentUser].objectId]){
        [self likePost];
        
    } else{
        [self unlikePost];
    }
}

#pragma mark - Setting like and unlike

- (void)likePost
{
    self.post.usersWhoLiked = [self.post.usersWhoLiked arrayByAddingObject:[PFUser currentUser].objectId];
    self.post.likeCount = @(self.post.likeCount.integerValue + 1);
    [self.post setValue:self.post.likeCount forKey:@"likeCount"];
    self.likeButton.selected = YES;
    self.postFavoriteCount.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    [self.post saveInBackground];
}

- (void)unlikePost
{
    NSMutableArray *deletionArray = [NSMutableArray arrayWithArray:self.post.usersWhoLiked];
    [deletionArray removeObject:[PFUser currentUser].objectId];
    NSLog(@"DeletionArray %@", deletionArray);
    self.post.usersWhoLiked = [NSArray arrayWithArray:deletionArray];
    self.post.likeCount = @(self.post.likeCount.integerValue - 1);
    self.likeButton.selected = NO;
    self.postFavoriteCount.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    [self.post saveInBackground];
}

@end

