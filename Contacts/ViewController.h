//
//  ViewController.h
//  Contacts
//
//  Created by Mahbub Morshed on 7/6/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsData.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSArray *searchResults;
}


@property(nonatomic,strong) ContactsData *selectedContact;
@property(nonatomic, strong) NSMutableArray *contactItems;
@property(nonatomic, strong) IBOutlet UITableView *contactsTable;
@property (strong, nonatomic) UISearchController *searchController;
@end


