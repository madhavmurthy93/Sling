//
//  MMCategoryTableViewController.m
//  Sling
//
//  Created by Madhav Murthy on 02/10/14.
//  Copyright (c) 2014 Madhav Murthy. All rights reserved.
//

#import "MMCategoryTableViewController.h"
#import "MMItemsTableViewController.h"
#import <Parse/Parse.h>

@interface MMCategoryTableViewController ()

@end

@implementation MMCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PFQuery *query = [PFQuery queryWithClassName:@"Categories"];
    [query orderByAscending:@"category"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            self.categories = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Category";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = [category objectForKey:@"category"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ items", [category objectForKey:@"items"]];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showItems"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *category = [self.categories objectAtIndex:indexPath.row];
        MMItemsTableViewController *itemsv = (MMItemsTableViewController *)segue.destinationViewController;
        itemsv.category = [category objectForKey:@"category"];
    } else if([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

#pragma mark - IBAction methods

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}
@end
