//
//  MMItemsTableViewController.m
//  Sling
//
//  Created by Madhav Murthy on 02/10/14.
//  Copyright (c) 2014 Madhav Murthy. All rights reserved.
//

#import "MMItemsTableViewController.h"
#import "MMItemViewController.h"
#import <Parse/Parse.h>

@interface MMItemsTableViewController ()

@end

@implementation MMItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.category;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Items"];
    [query whereKey:@"itemCategory" equalTo:self.category];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            self.items = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PFObject *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"itemTitle"];
    NSString *price = [item objectForKey:@"itemPrice"];
    NSDate *uploadTime = [item updatedAt];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd, h:mm a"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Price: %@ $, %@", price, [dateFormat stringFromDate:uploadTime]];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        PFObject *item = [self.items objectAtIndex:indexPath.row];
        MMItemViewController *controller = (MMItemViewController *) [segue destinationViewController];
        controller.item = item;
    }
}


@end
