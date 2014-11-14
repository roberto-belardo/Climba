//
//  RepetitionTableViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 20/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "RepetitionTableViewController.h"

@interface RepetitionTableViewController ()

@end

@implementation RepetitionTableViewController

@synthesize query;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        [self setTitle:@"Ripetizioni"];
        
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Repetition";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableData:) name:@"reloadTableData" object:nil];
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
    
    static NSString *RepetitionCellIdentifier = @"RepetitionCell";
    
    RepetitionCell *cell = (RepetitionCell *)[tableView dequeueReusableCellWithIdentifier:RepetitionCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"RepetitionCell" bundle:nil] forCellReuseIdentifier:RepetitionCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:RepetitionCellIdentifier];
        //        [cell setDelegate:self];
    }
    
    Repetition *repetition = (Repetition *)object;
    PFUser *user = repetition[@"user"];
    
    cell.user = user;
    
    cell.userNameLBL.text = [user objectForKey:@"profile"][@"name"];
    cell.repetitionModeLBL.text =repetition.type;
    cell.avatarUIImageView.image = [UIImage imageNamed:@"defaultRepetitionListAvatar.png"];
    if (![repetition.comment isEqualToString:@""]) {
        cell.repetitionComment.text = [NSString stringWithFormat:@"\"%@\"", repetition.comment];
    }else{
        cell.repetitionComment.text = @"";
    }
    
    
    [self setProfilePictureForCell:cell];
    
    //ROUTE BEAUTY STARS
    switch ([repetition.stars intValue]) {
        case 1:
            cell.repetitionBeautyImageView.image = [UIImage imageNamed:@"routebeauty1BLUE.png"];
            break;
        case 2:
            cell.repetitionBeautyImageView.image = [UIImage imageNamed:@"routebeauty2BLUE.png"];
            break;
        case 3:
            cell.repetitionBeautyImageView.image = [UIImage imageNamed:@"routebeauty3BLUE.png"];
            break;
        case 4:
            cell.repetitionBeautyImageView.image = [UIImage imageNamed:@"routebeauty4BLUE.png"];
            break;
        case 5:
            cell.repetitionBeautyImageView.image = [UIImage imageNamed:@"routebeauty5BLUE.png"];
            break;
        default:
            cell.repetitionBeautyImageView.image = [UIImage imageNamed:@"routebeauty3BLUE.png"];
            break;
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:repetition.createdAt];
    cell.repetitionDate.text = stringFromDate;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    if ([indexPath row] > self.objects.count -1) {
        return;
    }
    
    RepetitionCell *cellPressed = (RepetitionCell *)[tableView cellForRowAtIndexPath:indexPath];
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

-(void)reloadTableData:(NSNotification*)notification
{
    [self loadObjects:0 clear:YES];
}

- (void)setProfilePictureForCell:(RepetitionCell *)cell {
    
    cell.avatarUIImageView.layer.cornerRadius = cell.avatarUIImageView.frame.size.width / 2;
    cell.avatarUIImageView.clipsToBounds = YES;
    cell.avatarUIImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if(cell.user[@"profile"][@"pictureURL"]) {
        
        NSURL *profilePictureURL = [NSURL URLWithString:cell.user[@"profile"][@"pictureURL"]];
        [cell.avatarUIImageView setImageWithURL:profilePictureURL];
        
    }else{
        [self setProfilePictureFromParseForCell:cell];
    }
}

- (void)setProfilePictureFromParseForCell:(RepetitionCell *)cell {
    
    PFQuery *queryUserPhoto = [PFQuery queryWithClassName:@"UserPhoto"];
//    PFUser *userCurrent = [PFUser currentUser];
    [queryUserPhoto whereKey:@"user" equalTo:cell.user];
    [queryUserPhoto setLimit:1];
    [queryUserPhoto orderByAscending:@"createdAt"];
    
    [queryUserPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            
            PFObject *userPhoto = objects[0];
            
            PFFile *userImageFile = userPhoto[@"imageFile"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error && imageData) {
                    
                    UIGraphicsBeginImageContext(cell.avatarUIImageView.frame.size);
                    UIImage *image = [UIImage imageWithData:imageData];
                    [image drawInRect:cell.avatarUIImageView.bounds];
                    UIImage *avatar = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    cell.avatarUIImageView.image = avatar;
                }
            }];
        }
    }];
}


@end
