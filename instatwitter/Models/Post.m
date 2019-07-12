//
//  Post.m
//  instatwitter
//
//  Created by frankboamps on 7/9/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;
@dynamic profilePhoto;
@dynamic usersWhoLiked;

#pragma mark - Creating ParseClassName

+ (nonnull NSString *)parseClassName
{
    return @"Post";
}

#pragma mark - Posting user image

+ (void) postUserImage: ( UIImage *_Nullable )image withCaption: ( NSString *_Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion
{
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    newPost.usersWhoLiked = @[];
    [newPost saveInBackgroundWithBlock: completion];
}

#pragma mark - Getting PFFile

+ (PFFileObject *)getPFFileFromImage: (UIImage *_Nullable)image
{
    if (!image){
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData){
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
