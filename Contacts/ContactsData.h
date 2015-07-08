//
//  ContactsData.h
//  Contacts
//
//  Created by Mahbub Morshed on 7/8/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContactsData : NSObject

@property(nonatomic)  NSInteger *contactId;
@property(nonatomic, strong) NSString *firstNames;
@property(nonatomic, strong) NSString *lastNames;
@property(nonatomic, strong) NSString *fullName;
@property(nonatomic, strong) NSMutableArray *numbers;
@property(nonatomic, strong) NSMutableArray *emails;
@property(nonatomic, strong) UIImage *image;

@end
