//
//  DetailViewController.h
//  Contacts
//
//  Created by Mahbub Morshed on 7/8/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsData.h"

@interface DetailViewController : UIViewController{
    BOOL adding;
}

@property(nonatomic,strong) ContactsData *contact;

@property(nonatomic, strong) IBOutlet UIImageView *image;
@property(nonatomic, strong) IBOutlet UILabel *fullName;
@property(nonatomic, strong) IBOutlet UILabel *numbers;

@property(nonatomic, strong) IBOutlet UIButton *showNote;
@property(nonatomic, strong) IBOutlet UITextField *note;
@property(nonatomic, strong) IBOutlet UIButton *addNote;

@property(nonatomic, strong) IBOutlet UITextView *notes;

-(IBAction)back:(id)sender;
-(IBAction)toogleNotes:(id)sender;
@end
