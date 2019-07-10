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


@interface HomeFeedViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *instaPostTableView;

@property(strong, nonatomic) NSMutableArray *postArray;
@property(strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructQuery];
    self.instaPostTableView.delegate = self;
    self.instaPostTableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.instaPostTableView insertSubview:self.refreshControl atIndex:0];
}


 - (IBAction)didTapLogoutButton:(id)sender {
     [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
         
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
         [self presentViewController:loginViewController animated:YES completion:nil];
     }];
 }

-(void) constructQuery
{
PFQuery *query = [PFQuery queryWithClassName:@"Post"];
query.limit = 20;
[query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
    if (posts != nil) {
        self.postArray = [NSMutableArray arrayWithArray:posts];
        NSLog(@"%@", posts);
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
    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            cell.feedPostImageView.image = [UIImage imageWithData:data];
        }
    }];
    cell.feedCaptionLabel.text = post.caption;
    cell.postUserName.text = [NSString stringWithFormat:@"%@", post.author];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.postArray.count;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl
{
    
//     Create NSURL and NSURLRequest
//
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
//                                                          delegate:nil
//                                                     delegateQueue:[NSOperationQueue mainQueue]];
//    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
//                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
                                                // ... Use the new data to update the data source ...
                                                
                                                // Reload the tableView now that there is new data
    [self constructQuery];
//                                                [self.instaPostTableView reloadData];
//
//                                                // Tell the refreshControl to stop spinning
//                                                [refreshControl endRefreshing];
//
//                                                [self.instaPostTableView  reloadData];
//
   //                                         }];
    
 //   [task resume];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detailView" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     if ([[segue identifier] isEqualToString:@"detailView"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.instaPostTableView indexPathForCell:tappedCell];
        
        // Post *post = self.postArray[indexPath.row];
         DeatailsViewController *detailViewController = [segue destinationViewController];
        detailViewController.post = self.postArray[indexPath.row];
    }
    
    
}




@end
