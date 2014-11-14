//
//  FavFalesieListTableViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 03/10/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "FavFalesieListTableViewController.h"

@interface FavFalesieListTableViewController ()

@property (nonatomic, weak) Falesia *selectedFalesia;
@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToRegionMap;

@end

@implementation FavFalesieListTableViewController

@synthesize selectedFalesia, searchResults, content;
@synthesize sections = _sections;
@synthesize sectionToRegionMap = _sectionToRegionMap;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
        [self setTitle:@"Favorites"];
        
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"falesia";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"nome";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 50;
        
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToRegionMap = [NSMutableDictionary dictionary];
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
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
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
    
    [self.sections removeAllObjects];
    [self.sectionToRegionMap removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        NSString *regione = [object objectForKey:@"regione"];
        NSMutableArray *objectsInSection = [self.sections objectForKey:regione];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            
            // this is the first time we see this regione - increment the section index
            [self.sectionToRegionMap setObject:regione forKey:[NSNumber numberWithInt:(int)section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:(int)rowIndex++]];
        [self.sections setObject:objectsInSection forKey:regione];
    }
    [self.tableView reloadData];
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    NSArray *favoritesFalesieIds = [[Cache sharedCache] getFavouriteFalesie];
    NSLog(@"FavoriteFalesie - queryForTable");
    PFQuery *query = [Falesia query];
    [query whereKey:@"objectId" containedIn:favoritesFalesieIds];
    [query whereKey:@"available" equalTo:[NSNumber numberWithBool:true]];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query orderByAscending:@"regione"];
    
    if([ReachabilityManager isReachable]) {
        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    }else{
        query.cachePolicy = kPFCachePolicyCacheOnly;
        [Utility networkUnreachableTSMessage:self];
    }
    return query;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSString *regione = [self regionForSection:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.sections objectForKey:regione];
    
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
//    if (indexPath.section == self.objects.count) {
//        
//        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
//        return cell;
//    }
    
    static NSString *FalesiaCellIdentifier = @"FalesiaCell";
    
    FalesiaCell *cell = (FalesiaCell *)[tableView dequeueReusableCellWithIdentifier:FalesiaCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"FalesiaCell" bundle:nil] forCellReuseIdentifier:FalesiaCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:FalesiaCellIdentifier];
    }

    Falesia *falesia = (Falesia *)object;
    cell.nomeFalesiaLabel.text = falesia.nome;
    cell.nomeProvinciaLabel.text = falesia.provincia;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger sections = self.sections.allKeys.count;
//    NSLog(@"OBJECTS: %d - PER PAGE: %d", (int)self.objects.count, (int)self.objectsPerPage);
//    if (self.paginationEnabled && sections != 0 && self.objects.count >= self.objectsPerPage)
//        sections++;
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section >= self.sections.allKeys.count) {
//        return 1;
//    }else{
        NSString *regione = [self regionForSection:section];
        NSArray *rowIndecesInSection = [self.sections objectForKey:regione];
        return rowIndecesInSection.count;
//    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section >= self.sections.allKeys.count) {
//        return @"Load More";
//    }else{
        NSString *regione = [self regionForSection:section];
        return regione;
//    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
//    if (indexPath.section == self.objects.count && self.paginationEnabled) {
//        // Load More Cell
//        [self loadNextPage];
//    }
    
    //Check wheter the cell tapped is not the "Load More"
    UITableViewCell *cellPressed = [tableView cellForRowAtIndexPath:indexPath];
    if([cellPressed isKindOfClass:[FalesiaCell class]]) {
        
//        Falesia *falesia = (Falesia *)[self.objects objectAtIndex:indexPath.row];
        Falesia *falesia = (Falesia *)[self objectAtIndexPath:indexPath];
        
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
    
//    Falesia *falesia = (Falesia *)[self.objects objectAtIndex:indexPath.row];
    Falesia *falesia = (Falesia *)[self objectAtIndexPath:indexPath];
    
    //Display the detail view
    FalesiaDetailViewController *falesiaDetailViewController = [[FalesiaDetailViewController alloc] init];
    falesiaDetailViewController.delegate = self;
    falesiaDetailViewController.falesia = falesia;
    [self presentViewController:falesiaDetailViewController animated:YES completion:nil];
    
}

#pragma mark - FalesiaDetailViewControllerDelegate

- (void) didDismissFalesiaDetailVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewRowAction

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *actionFav = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Remove" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
//        Falesia *falesia = (Falesia *)[self.objects objectAtIndex:indexPath.row];
        Falesia *falesia = (Falesia *)[self objectAtIndexPath:indexPath];
        [self.tableView setEditing:NO animated:YES];
        [[Cache sharedCache] removeFalesiaFromFavourites:falesia.objectId];
        
        [self loadObjects];
        
    }];
    
    return @[actionFav];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

- (NSString *)regionForSection:(NSInteger)section {
    return [self.sectionToRegionMap objectForKey:[NSNumber numberWithInt:(int)section]];
}

@end
