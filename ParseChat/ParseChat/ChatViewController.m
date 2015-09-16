//
//  ChatViewController.m
//  ParseChat
//
//  Created by Cristan Zhang on 9/16/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "Utility.h"
#import "SettingViewController.h"
#import "LoginViewController.h"

#import "AccountManager.h"

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UILabel *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIRefreshControl *refreshControl;
@property NSArray* messageList;
@property AccountManager* accountManager;
@property BOOL bFilterByUser;

@end

@implementation ChatViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.title = @"Parse Chat";
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //add settings item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(showSettingView)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"FilterUser" style:UIBarButtonItemStylePlain target:self action:@selector(filterByUser)];
    
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //add a PTR control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    _accountManager = [AccountManager sharedManager];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.leftBarButtonItem.title = _bFilterByUser? @"AllMessage":@"MyMessage";
    if([_accountManager isLoggedIn]) {
        //load previous messages
        [self retrieveMessages];
    } else {
        [self showLoginView];
    }
}

-(void)filterByUser {
    _bFilterByUser = !_bFilterByUser;
    self.navigationItem.leftBarButtonItem.title = _bFilterByUser? @"AllMessage":@"MyMessage";
    [self onRefresh];
}

-(void)showSettingView {
    SettingViewController* viewController = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

//show login view modally
-(void)showLoginView {
    LoginViewController* viewController = [[LoginViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)onRefresh {
    [self retrieveMessages];
}


- (IBAction)onSend:(id)sender {
    PFObject* message = [PFObject objectWithClassName:kMessageClassName];
    message[kMessageTextPropertyName] = self.textInput.text;
    if(_bFilterByUser) {
        message[kMessageUserPropertyName] = [_accountManager currentUser];
    }
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"Message sent: %@", message[kMessageTextPropertyName]);
            self.textInput.text = @"";
            [self onRefresh];
        } else {
            // There was a problem, check error.description
            NSString *errorString = [error userInfo][@"error"];
            [Utility showAlert:self with:@"Send Message Failed" withMessage:errorString];
        }
    }];
}

- (void) retrieveMessages {
    AccountManager* manager = [AccountManager sharedManager];
    PFQuery *query = [PFQuery queryWithClassName:kMessageClassName];
    //sort by create time
    [query orderByDescending:@"createdAt"];
    
    if(_bFilterByUser) {
        PFUser* author = [manager currentUser];
        
        // configure any constraints on your query...
        [query whereKey:kMessageUserPropertyName equalTo:author];
        
    // tell the query to fetch all of the Author objects along with the Book
        [query includeKey:kMessageUserPropertyName];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.messageList = objects;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        });
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %li scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object[kMessageTextPropertyName]);
            }
        } else {
            // Log details of the failure
            [Utility showAlert:self with:@"Get Message Failed" withMessage:error.description];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    NSInteger row = indexPath.row;
    PFObject* object = _messageList[row];
    cell.textLabel.text = object[kMessageTextPropertyName];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
