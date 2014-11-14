//
//  UserProfileRepetitionTableViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 26/09/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "UserProfileRepetitionTableViewController.h"

@interface UserProfileRepetitionTableViewController ()

@end

@implementation UserProfileRepetitionTableViewController

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
        self.objectsPerPage = 15;
        
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
    
    static NSString *UserProfileRepetitionTableViewCellIdentifier = @"UserProfileRepetitionTableViewCell";
    
    UserProfileRepetitionTableViewCell *cell = (UserProfileRepetitionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:UserProfileRepetitionTableViewCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"UserProfileRepetitionTableViewCell" bundle:nil] forCellReuseIdentifier:UserProfileRepetitionTableViewCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:UserProfileRepetitionTableViewCellIdentifier];
        //        [cell setDelegate:self];
    }
    
    Repetition *repetition = (Repetition *)object;
    Via *via = repetition.via;
    Settore *settore = via[@"settore"];
    Falesia *falesia = settore[@"falesia"];
    
    cell.routeNameLabel.text = via.nome;
    cell.routeGradeLabel.text = via.grado;
    NSString *routeFalesiaAndSectorLabelText = [NSString stringWithFormat:@"%@ (%@)", falesia.nome, settore.nome];
    cell.routeFalesiaAndSectorLabel.text = routeFalesiaAndSectorLabelText;
    if (![repetition.comment isEqualToString:@""]) {
        cell.repetitionCommentLabel.text = [NSString stringWithFormat:@"\"%@\"", repetition.comment];
    } else {
        cell.repetitionCommentLabel.text = @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:repetition.createdAt];
    cell.repetitionDateLabel.text = stringFromDate;
    cell.repetitionModeLabel.text =repetition.type;

    //ROUTE BEAUTY STARS
    switch ([via.bellezza intValue]) {
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

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
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


@end
