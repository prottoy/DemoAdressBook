//
//  DetailViewController.m
//  Contacts
//
//  Created by Mahbub Morshed on 7/8/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize image, fullName, numbers;
@synthesize contact;
@synthesize showNote, note, addNote, notes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *number;
    for (NSString *n in contact.numbers) {
        if (number.length > 0) {
            number= [NSString stringWithFormat:@"%@,%@",number,n];
        }else
            number= n;
    }
    
    [self.image setImage:contact.image];
    self.fullName.text= contact.fullName;
    self.numbers.text= number;
    
    adding= YES;
    self.notes.hidden = NO;
    self.addNote.hidden= NO;
    self.note.hidden = NO;
    
    NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
    NSString *contactId=[NSString stringWithFormat:@"%d",(int)contact.contactId];
    notes.text= [prefs objectForKey:contactId];
    
    NSLog(@"%@",[prefs objectForKey:contactId]);
    
    image.layer.cornerRadius= image.frame.size.width/2;
    image.layer.borderColor=[UIColor blackColor].CGColor;
    image.layer.borderWidth= 2.0;
    image.clipsToBounds= YES;
}

-(IBAction)toogleNotes:(id)sender{
    if (adding) {
        adding= NO;
        self.notes.hidden = YES;
        self.addNote.hidden= YES;
        self.note.hidden = YES;
    }else{
        adding= YES;
        self.notes.hidden = NO;
        self.addNote.hidden= NO;
        self.note.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)addNote:(id)sender{
    NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
    NSString *currentNote= note.text;
    NSString *contactId=[NSString stringWithFormat:@"%d",(int)contact.contactId];
    NSString *oldNote= [prefs objectForKey:contactId];
    
    if (oldNote.length < 1) {
        oldNote=@"";
    }
    NSString *noteToAdd= [NSString stringWithFormat:@"%@ \n%@", oldNote, currentNote];
    
    [prefs setObject:noteToAdd forKey:contactId];
    
    notes.text= noteToAdd;
    self.note.text=@"";
    [self.note resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
