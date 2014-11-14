//
//  ActivityFeedTableViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 21/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "ActivityFeedTableViewController.h"

@implementation ActivityFeedTableViewController

@synthesize query;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        [self setTitle:@"Activity"];
        
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Activity";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 15;
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
    if (!self.query) {
        [self objectsDidLoad:nil];
    }
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    if([ReachabilityManager isReachable]) {
        return self.query;
    }else{
        [Utility networkUnreachableTSMessage];
        [super objectsDidLoad:nil];
        return nil;
    }
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *ActivityFeedCellIdentifier = @"ActivityFeedCell";
    
    ActivityFeedCell *cell = (ActivityFeedCell *)[tableView dequeueReusableCellWithIdentifier:ActivityFeedCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ActivityFeedCell" bundle:nil] forCellReuseIdentifier:ActivityFeedCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:ActivityFeedCellIdentifier];
        //        [cell setDelegate:self];
    }
    
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    Activity *activity = (Activity *)object;
    PFUser *user = activity[@"fromUser"];
    Repetition *repetition = activity.repetition;
    Via *via = repetition.via;
    NSString *falesiaName = [NSString stringWithFormat:@"%@ - (%@)", repetition[@"falesia"], repetition[@"settore"]];
    
    cell.userLBL.text = [user objectForKey:@"profile"][@"name"];
    cell.routeNameLBL.text = via.nome;
    cell.falesiaNameLBL.text = falesiaName;
    cell.user = user;
    cell.routeMode.text = repetition.type;
    cell.routeGradeLBL.text = via.grado;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    cell.activityCreatedAtLBL.text = [formatter stringFromDate:activity.createdAt];
    
    //ROUTE BEAUTY STARS
    switch ([via.bellezza intValue]) {
        case 1:
            cell.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty1BLUE.png"];
            break;
        case 2:
            cell.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty2BLUE.png"];
            break;
        case 3:
            cell.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty3BLUE.png"];
            break;
        case 4:
            cell.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty4BLUE.png"];
            break;
        case 5:
            cell.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty5BLUE.png"];
            break;
        default:
            cell.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty3BLUE.png"];
            break;
    }
    
    //USER PROFILE PICTURE
    [self setProfilePictureForCell:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityFeedCell *cellPressed = (ActivityFeedCell *)[tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = cellPressed.user;
    UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    userProfileVC.user = user;
    
    [self.navigationController pushViewController:userProfileVC animated:YES];
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - ()
- (void)setProfilePictureForCell:(ActivityFeedCell *)cell {
    
    cell.userProfilePictureImageView.layer.cornerRadius = cell.userProfilePictureImageView.frame.size.width / 2;
    cell.userProfilePictureImageView.clipsToBounds = YES;
    cell.userProfilePictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if(cell.user[@"profile"][@"pictureURL"]) {
        
        NSURL *profilePictureURL = [NSURL URLWithString:cell.user[@"profile"][@"pictureURL"]];
        [cell.userProfilePictureImageView setImageWithURL:profilePictureURL];
        
    }else{
        [self setProfilePictureFromParseForCell:cell forUser:cell.user];
    }
}

- (void)setProfilePictureFromParseForCell:(ActivityFeedCell *)cell forUser:(PFUser *)user {
    
    PFQuery *queryUserPhoto = [PFQuery queryWithClassName:@"UserPhoto"];
    [queryUserPhoto whereKey:@"user" equalTo:user];
    [queryUserPhoto setLimit:1];
    [queryUserPhoto orderByAscending:@"createdAt"];
    
    [queryUserPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            
            PFObject *userPhoto = objects[0];
            
            PFFile *userImageFile = userPhoto[@"imageFile"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error && imageData) {
                    
                    UIGraphicsBeginImageContext(cell.userProfilePictureImageView.frame.size);
                    UIImage *image = [UIImage imageWithData:imageData];
                    [image drawInRect:cell.userProfilePictureImageView.bounds];
                    UIImage *avatar = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    cell.userProfilePictureImageView.image = avatar;
                }
            }];
        }
    }];
}


@end
