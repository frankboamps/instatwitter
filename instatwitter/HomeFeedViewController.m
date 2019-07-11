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

@interface HomeFeedViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *instaPostTableView;
@property(strong, nonatomic) NSMutableArray *postArray;
@property(strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation HomeFeedViewController

bool isMoreDataLoading = NO;
InfiniteScrollActivityView *loadingMoreView;

- (void)viewDidLoad {
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


 - (IBAction)didTapLogoutButton:(id)sender
{
     [PFUser logOutInBackgroundWithBlock:^(NSError *_Nullable error) {
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
         [self presentViewController:loginViewController animated:YES completion:nil];
     }];
 }

-(void) constructQuery
{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
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


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    InataPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instaCell" forIndexPath:indexPath];
    Post *post = self.postArray[indexPath.row];
    //cell.delegate = self;
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *_Nullable data, NSError *_Nullable error) {
        if (!error) {
            cell.feedPostImageView.image = [UIImage imageWithData:data];
        }
    }];
    cell.feedCaptionLabel.text = post.caption;
    cell.postUserName.text = post.author.username;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.postArray.count;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifier];
//    header.textLabel.text = [data[section] firstObject];
//    return header;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl
{
    [self constructQuery];
}

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
           // [self loadMoreData];
        }
    }
}

-(void)loadMoreData{
    [self constructQuery];
}



#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailView"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.instaPostTableView indexPathForCell:tappedCell];
        DeatailsViewController *detailViewController = [segue destinationViewController];
        Post *post = self.postArray[indexPath.row];
        detailViewController.post = post;
    }
}

@end
