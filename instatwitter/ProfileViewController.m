//
//  ProfileViewController.m
//  instatwitter
//
//  Created by frankboamps on 7/10/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "HomeFeedViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "Post.h"
#import "InstaCollectionCell.h"
#import "InataPostTableViewCell.h"
#import "DeatailsViewController.h"
#import <UIKit/UIKit.h>

@interface ProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *userPostArray;
@property (weak, nonatomic) IBOutlet UILabel *userProfileName;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *userName = PFUser.currentUser.username;
    self.userProfileName.text = userName;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self refreshData];
}

-(void)refreshData{
    
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.userPostArray = posts;
            [self.collectionView reloadData];
            // do something with the data fetched
        }
        else {
            // handle error
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InstaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"instaCollectionCell" forIndexPath:indexPath];
    
    Post *post = self.userPostArray[indexPath.row];
    cell.post = post;
    NSString *post_image_address = post.image.url;
    NSURL *postImageURL = [NSURL URLWithString:post_image_address];
    cell.postedImage.image = nil;
    [cell.postedImage setImageWithURL:postImageURL];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPostArray.count;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"postDetailSegue"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.userPostArray[indexPath.row];
        DeatailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = post;
    }
}


@end
