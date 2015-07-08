//
//  ViewController.m
//  Contacts
//
//  Created by Mahbub Morshed on 7/6/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import "ContactsData.h"
#import "ContactTableViewCell.h"
#import "DetailViewController.h"

@interface ViewController ()
-(void)printAllContacts:(NSMutableArray *)items;
@end

@implementation ViewController
@synthesize contactsTable, contactItems;
@synthesize searchController;
@synthesize selectedContact;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    contactItems= [[NSMutableArray alloc] init];
    
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonCountry",@"Country"),
                                                          NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
    self.searchController.searchBar.delegate = self;
    
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, get the contact
                contactItems=[[self getAllContacts] mutableCopy];
            } else {
                // User denied access
                // Displaying an alert telling user the contact could not be loaded
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The contact can not be loaded" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alert show];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self printAllContacts:[[self getAllContacts] mutableCopy]];
        contactItems=[[self getAllContacts] mutableCopy];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"This app needs permimssion to get user contacts. Please change privacy in the settings." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }
    searchResults= contactItems;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)printAllContacts:(NSMutableArray *)items{
    for (ContactsData *contact in items) {
        NSLog(@"==================================================================================");
        NSLog(@"Contact full name is [%@]", contact.fullName);
        NSLog(@"Number is- ");
        for (NSString *number in contact.numbers) {
            NSLog(@"[%@]", number);
        }
        NSLog(@"Email is- ");
        for (NSString *email in contact.emails) {
            NSLog(@"[%@]", email);
        }
        NSLog(@"==================================================================================");
    }
}

- (NSArray *)getAllContacts {
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
    //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    CFIndex nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
    
    if (!allPeople || !nPeople) {
        NSLog(@"people nil");
    }
    
    
    for (int i = 0; i < nPeople; i++) {
        @autoreleasepool {
            //data model
            ContactsData *contacts = [ContactsData new];
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name
            CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
//            NSString *fname= [(__bridge NSString*)firstName copy];
            contacts.firstNames = [(__bridge NSString*)firstName copy];
            
            if (firstName != NULL) {
                CFRelease(firstName);
            }
            
            
            //get Last Name
            CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
            contacts.lastNames = [(__bridge NSString*)lastName copy];
//            NSString *lname= [(__bridge NSString*)lastName copy];
            
            if (lastName != NULL) {
                CFRelease(lastName);
            }
            
            
            if (!contacts.firstNames) {
                contacts.firstNames = @"";
            }
            
            if (!contacts.lastNames) {
                contacts.lastNames = @"";
            }
            
            contacts.contactId = (NSInteger *)ABRecordGetRecordID(person);
            //append first name and last name
            contacts.fullName = [NSString stringWithFormat:@"%@ %@", contacts.firstNames, contacts.lastNames];

            
            // get contacts picture, if pic doesn't exists, show standart one
            CFDataRef imgData = ABPersonCopyImageData(person);
            NSData *imageData = (__bridge NSData *)imgData;
            contacts.image = [UIImage imageWithData:imageData];
            
            if (imgData != NULL) {
                CFRelease(imgData);
            }
            
            if (!contacts.image) {
                contacts.image = [UIImage imageNamed:@"avatar.png"];
            }
            
            
            //get Phone Numbers
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for(CFIndex i=0; i<ABMultiValueGetCount(multiPhones); i++) {
                @autoreleasepool {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
                    if (phoneNumber != nil)[phoneNumbers addObject:phoneNumber];
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiPhones);
            }
            
            [contacts setNumbers:phoneNumbers];
            
            
            //get Contact email
            NSMutableArray *contactEmails = [NSMutableArray new];
            ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            
            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                @autoreleasepool {
                    CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                    NSString *contactEmail = CFBridgingRelease(contactEmailRef);
                    if (contactEmail != nil)[contactEmails addObject:contactEmail];
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiEmails);
            }
            
            [contacts setEmails:contactEmails];
            [items addObject:contacts];

#ifdef DEBUG

#endif
        }
    } //autoreleasepool
    CFRelease(allPeople);
    CFRelease(addressBook);
    CFRelease(source);
    return items;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
    
    NSLog(@"Contacts item [%lu]",(unsigned long)[contactItems count]);
        return [contactItems count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"contactIdentifier";
    
    ContactTableViewCell *cell = [self.contactsTable dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier] ;
    }
    
    ContactsData  *contact;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact= [searchResults objectAtIndex:indexPath.row];
    } else {
      contact= [contactItems objectAtIndex:indexPath.row];
    }
    
    [cell.image setImage:contact.image];
    cell.fullname.text= contact.fullName;
    cell.phoneNumber.text= [contact.numbers objectAtIndex:0];
    
    NSLog(@"Full Name [%@]", contact.fullName);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactsData  *contact;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact= [searchResults objectAtIndex:indexPath.row];
    } else {
        contact= [contactItems objectAtIndex:indexPath.row];
    }
    
    
    NSString *message;
    self.selectedContact= contact;
    
    for (int i=0; i<[contact.numbers count]; i++) {
        NSString *number= [contact.numbers objectAtIndex:i];
        if ([message isEqualToString:@""]) {
            message= [NSString stringWithFormat:@"%@ , %@",message,number];
        }else
            message= number;
    }
    
    [self performSegueWithIdentifier:@"showDetails" sender:contact];

//    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:contact.fullName message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
////    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    DetailViewController *detailVC = segue.destinationViewController;
    detailVC.contact =self.selectedContact;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"fullName contains %@",searchText];
    searchResults = [contactItems filteredArrayUsingPredicate:resultPredicate];
    
    [self printAllContacts:[searchResults mutableCopy]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
@end
