//
//  HomeFeedViewController.m
//  instatwitter
//
//  Created by frankboamps on 7/8/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "HomeFeedViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "Post.h"
#import "InataPostTableViewCell.h"
#import "DeatailsViewController.h"
#import <UIKit/UIKit.h>
#import "InfiniteScrollActivityView.h"
#import "UIImageView+AFNetworking.h"

@interface HomeFeedViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *instaPostTableView;
@property(strong, nonatomic) NSMutableArray *postArray;
@property(strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation HomeFeedViewController

bool isMoreDataLoading = NO;
InfiniteScrollActivityView *loadingMoreView;

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self constructQuery];
    self.instaPostTableView.delegate = self;
    self.instaPostTableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.instaPostTableView insertSubview:self.refreshControl atIndex:0];
    CGRect frame = CGRectMake(0, self.instaPostTableView.contentSize.height, self.instaPostTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.instaPostTableView addSubview:loadingMoreView];
    UIEdgeInsets insets = self.instaPostTableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.instaPostTableView.contentInset = insets;
}

#pragma mark - Setting up tap log out button

- (IBAction)didTapLogoutButton:(id)sender
{
    [PFUser logOutInBackgroundWithBlock:^(NSError *_Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }];
}

#pragma mark - constructing querry to request data

-(void) constructQuery
{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postArray = [NSMutableArray arrayWithArray:posts];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [self.instaPostTableView  reloadData];
    }];
}

#pragma mark - Setting up tableview delegates

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    InataPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instaCell" forIndexPath:indexPath];
    Post *post = self.postArray[indexPath.row];
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *_Nullable data, NSError *_Nullable error) {
        if (!error) {
            cell.feedPostImageView.image = [UIImage imageWithData:data];
        }
    }];
    cell.feedCaptionLabel.text = post.caption;
    cell.postUserName.text = post.author.username;
    PFFileObject *authorProfilePicture = post.author[@"profileImage"];
    NSURL *authorProfilePictureURL = [NSURL URLWithString:authorProfilePicture.url];
    cell.postUserImage.image = nil;
    [cell.postUserImage setImageWithURL:authorProfilePictureURL];
    if ([cell.post.usersWhoLiked containsObject:[PFUser currentUser].objectId]){
        cell.likeButton.selected = YES;
    } else {
        cell.likeButton.selected = NO;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.postArray.count;
}

#pragma mark - Setting up begin refreshControl

- (void)beginRefresh:(UIRefreshControl *)refreshControl
{
    [self constructQuery];
}

#pragma mark - Setting up scroll for scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.instaPostTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.instaPostTableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.instaPostTableView.isDragging) {
            self.isMoreDataLoading = true;
            CGRect frame = CGRectMake(0, self.instaPostTableView.contentSize.height, self.instaPostTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
        }
    }
}

#pragma mark - loading and refreshing data
-(void)loadMoreData
{
    [self constructQuery];
}

-(void)refreshData
{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.postArray = posts;
            [self.instaPostTableView reloadData];
        }
        else {
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailView"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.instaPostTableView indexPathForCell:tappedCell];
        DeatailsViewController *detailViewController = [segue destinationViewController];
        Post *post = self.postArray[indexPath.row];
        detailViewController.post = post;
    }
}

@end
