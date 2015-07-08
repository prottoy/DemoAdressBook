//
//  ContactTableViewCell.h
//  Contacts
//
//  Created by Mahbub Morshed on 7/8/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *image;
@property(nonatomic, strong) IBOutlet UILabel *fullname;
@property(nonatomic, strong) IBOutlet UILabel *phoneNumber;
@end
