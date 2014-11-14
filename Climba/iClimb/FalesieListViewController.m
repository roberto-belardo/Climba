//
//  FalesieListViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 28/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "FalesieListViewController.h"

@interface FalesieListViewController ()

@property (nonatomic, weak) Falesia *selectedFalesia;

@end

@implementation FalesieListViewController

@synthesize regione, selectedFalesia;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
//        [self setTitle:self.regione.nome];
        
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"falesia";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"nome";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self setTitle:self.regione.nome];
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    PFQuery *query = [Falesia query];
    [query whereKey:@"regione" equalTo:self.regione.nome];
    [query whereKey:@"available" equalTo:[NSNumber numberWithBool:true]];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    // If Pull To Refresh is enabled, query against the network by default.
    //    if (self.pullToRefreshEnabled) {
    //        query.cachePolicy = kPFCachePolicyNetworkOnly;
    //    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //    if (self.objects.count == 0) {
    //        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //    }
    
    [query orderByAscending:@"nome"];
    
    return query;
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *FalesiaCellIdentifier = @"FalesiaCell";
    
    FalesiaCell *cell = (FalesiaCell *)[tableView dequeueReusableCellWithIdentifier:FalesiaCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"FalesiaCell" bundle:nil] forCellReuseIdentifier:FalesiaCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:FalesiaCellIdentifier];
//        [cell setDelegate:self];
    }
    
    // Configure the cell
    
    Falesia *falesia = (Falesia *)object;
    cell.nomeFalesiaLabel.text = falesia.nome;
    cell.nomeProvinciaLabel.text = falesia.provincia;
    
    return cell;
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

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    //Check wheter the cell tapped is not the "Load More"
    UITableViewCell *cellPressed = [tableView cellForRowAtIndexPath:indexPath];
    if([cellPressed isKindOfClass:[FalesiaCell class]]) {
        
        Falesia *falesia = (Falesia *)[self.objects objectAtIndex:indexPath.row];
        
        self.selectedFalesia = falesia;
        
        NSLog(@"%@", self.selectedFalesia.nome);
        
        //Retrieve every Sector of the current Falesia:
        
        PFQuery *query = [Settore query];
        [query whereKey:@"falesia" equalTo:falesia];
        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
        [query orderByDescending:@"nome"];
        [query findObjectsInBackgroundWithTarget:self
                                        selector:@selector(findSettoriCallback:error:)];
        
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"Accessory Button for Cell #%i in section #%i",indexPath.row,indexPath.section);
    
    Falesia *falesia = (Falesia *)[self.objects objectAtIndex:indexPath.row];
    
    //Display the detail view
    FalesiaDetailViewController *falesiaDetailViewController = [[FalesiaDetailViewController alloc] init];
    falesiaDetailViewController.delegate = self;
    falesiaDetailViewController.falesia = falesia;
    [self presentViewController:falesiaDetailViewController animated:YES completion:nil];
    
}

#pragma mark UITableViewRowAction

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *actionFav = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Star" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        Falesia *falesia = (Falesia *)[self.objects objectAtIndex:indexPath.row];

        if([[[Cache sharedCache] getFavouriteFalesie] count] < 50) {
            [self.tableView setEditing:NO animated:YES];
            [[Cache sharedCache] addFalesiaToFavourites:falesia.objectId];
            
            [TSMessage showNotificationInViewController:self
                                                  title:@"Added to favorites!"
                                               subtitle:[NSString stringWithFormat:@"%@ succesfully added to the favorites list.", falesia.nome]
                                                   type:TSMessageNotificationTypeSuccess];
        }else{
            [TSMessage showNotificationInViewController:self
                                                  title:@"Cannot add it to favorites"
                                               subtitle:[NSString stringWithFormat:@"It seems you already have 50 falesie among your favorites. Please remove one of them and try add %@ again.", falesia.nome]
                                                   type:TSMessageNotificationTypeError];
        }
    }];
    
    actionFav.backgroundColor = [UIColor colorWithRed:33.0f/255.0f green:164.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    
    return @[actionFav];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - FalesiaDetailViewControllerDelegate

- (void) didDismissFalesiaDetailVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ()

- (void)findSettoriCallback:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        
        RoutesListViewController *routesListVC = [RoutesListViewController new];
        routesListVC.falesia = self.selectedFalesia;
        routesListVC.settori = [NSMutableArray arrayWithArray:objects];
        
        [self.navigationController pushViewController:routesListVC animated:YES];
        
    } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        
        [TSMessage showNotificationInViewController:self
                                              title:@"Error"
                                           subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                               type:TSMessageNotificationTypeError];
    }
}

@end
