//
//  ContactTableViewCell.m
//  Contacts
//
//  Created by Mahbub Morshed on 7/8/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell
@synthesize image, fullname, phoneNumber;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
