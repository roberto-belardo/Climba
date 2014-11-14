//
//  RoutesListViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 28/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "RoutesListViewController.h"

@interface RoutesListViewController ()

@end

@implementation RoutesListViewController

@synthesize settori, searchResults, content;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
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
    [super viewDidLoad];
    
    [self setTitle:self.falesia.nome];

    [self findSectorsAndRoutes];
    
    self.searchResults = [[NSMutableArray alloc] initWithCapacity: [self.content count]];
    [self.searchResults addObjectsFromArray: self.content];
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


#pragma mark - PFQuery

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForSector:(Settore *)settore {
    
    PFQuery *query = [Via query];
    [query whereKey:@"settore" equalTo:settore];
    [query includeKey:@"settore"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query orderByAscending:@"oldID"];
    
    return query;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.searchResults count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.searchResults objectAtIndex:section] objectForKey:@"rowValues"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RouteCell";
    
    RouteCell *cell = (RouteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    Via *via = [[[self.searchResults objectAtIndex:indexPath.section]objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    
    // Configure the cell
    cell.routeNameLabel.text = via.nome;
    if (isnumber([via.grado characterAtIndex:0])) {
        cell.routeGradeLabel.text = via.grado;
    }else{
        cell.routeGradeLabel.text = @"n/d";
    }
    
    
    return cell;
}

#pragma mark Sectioned Table View Methods

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [_indices indexOfObject:title];
//}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	return [[self.searchResults objectAtIndex:section] objectForKey:@"headerTitle"];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RouteViewController *routeVC = [[RouteViewController alloc] initWithNibName:@"RouteViewController" bundle:nil];
    
    Via *via = [[[self.searchResults objectAtIndex:indexPath.section]objectForKey:@"rowValues"] objectAtIndex:indexPath.row];

    if (isnumber([via.grado characterAtIndex:0])) {
        NSString *sectorName= [[self.searchResults objectAtIndex:indexPath.section] objectForKey:@"headerTitle"];
        
        routeVC.via = via;
        routeVC.falesiaName = self.falesia.nome;
        routeVC.sectorName = sectorName;
        
        [self.navigationController pushViewController:routeVC animated:YES];
    } else {
        [TSMessage showNotificationInViewController:self
                                              title:@"Wooooooah!"
                                           subtitle:@"This route is still a mistery..."
                                               type:TSMessageNotificationTypeWarning];
    }
    
}

#pragma mark - ()

- (void)findSectorsAndRoutes {
    
    for (Settore *settore in self.settori) {
        
        PFQuery *query = [self queryForSector:settore];
        [query findObjectsInBackgroundWithTarget:self selector:@selector(updateSectorsAndRoutes:error:)];

    }
}

- (void)updateSectorsAndRoutes:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        Settore *settore = objects[0][@"settore"];
        [row setValue:settore.nome forKey:@"headerTitle"];
        [row setValue:objects forKey:@"rowValues"];
        
        [self.searchResults addObject:row];
        
        //Order searchResults alphabetically
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"headerTitle" ascending:YES];
        [self.searchResults sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];

        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
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
