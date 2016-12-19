//
//  HNUserListViewController.m
//  Dolphin
//
//  Created by 红鸟的起源 on 16/4/23.
//  Copyright © 2016年 红鸟的起源. All rights reserved.
//

#import "HNUserListViewController.h"

#import "HNTableViewCell.h"
#import "HNContactTableViewController.h"
#import "ADSwipeTransition.h"
#import "ADTransitioningDelegate.h"
static int ix = 0;
@interface HNUserListViewController ()<QBChatDelegate,UISearchResultsUpdating,UIScrollViewDelegate>
@property(nonatomic,strong)UISwipeGestureRecognizer *rightSwipeTocontact;
@property(nonatomic,strong)ConfirmaddFriendsView *conformView;
@property(nonatomic,assign)NSInteger addid;
@property(nonatomic,strong)UISearchController *searchcontroller;
@property(nonatomic,strong)NSMutableArray *arrsearch;
@property(nonatomic,strong)NSMutableArray *arremilaall;
@property(nonatomic,strong)NSMutableArray *fullnameall;
@property(nonatomic,strong)UIView *viewbar;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation HNUserListViewController
-(NSMutableArray *)arrsearch
{
    if (!_arrsearch) {
        _arrsearch=[NSMutableArray array];
    }
    return _arrsearch;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paginator = [[UsersPaginator alloc] initWithPageSize:30 delegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getdataToreloa) name:@"GETNOTFRIEDS" object:nil];
    [self.navigationController.navigationBar setBarTintColor:LoginAndRegistColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    self.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"用户列表" image:[UIImage imageNamed:@"ModernContactListInviteFriendsIcon"]  selectedImage:[UIImage imageNamed:@"ModernContactListInviteFriendsIcon"]];

    self.viewbar=[[UIView alloc]initWithFrame:CGRectMake(0, 68, self.view.frame.size.width, 70)];
    //self.viewbar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.viewbar];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.enabled=NO;
    
    [addButton  setBackgroundColor:[UIColor clearColor]];
    //[addButton setImage:addImage forState:UIControlStateNormal];
    
    [addButton setContentMode:UIViewContentModeLeft];
    [addButton setFrame:CGRectMake(0, 0, 50, 50)];
    
    addButton.imageEdgeInsets=UIEdgeInsetsMake(18, 0, 18, 36);
    
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    self.navigationItem.leftBarButtonItem.enabled=NO;
//    [addButton addTarget:self action:@selector(backToCenter) forControlEvents:UIControlEventTouchUpInside];

    
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    self.tableview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tableview];
   // [self.tableview reloadData];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkusersAndUpdatetable) name:@"HNUSERSCHECK" object:nil];

//    self.rightSwipeTocontact=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeTocontactAction)];
//    self.rightSwipeTocontact.direction=UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:self.rightSwipeTocontact];
    [[QBChat instance] addDelegate:self];
    self.conformView=[[ConfirmaddFriendsView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 50)];
    [self.conformView.rejectbtn addTarget:self action:@selector(rejectaddfriend) forControlEvents:UIControlEventTouchUpInside];
    [self.conformView.addBtn addTarget:self action:@selector(addfriend) forControlEvents:UIControlEventTouchUpInside];
    
    self.conformView.hidden=YES;
    [self.view addSubview:self.conformView];
    

    self.searchcontroller=[[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchcontroller.searchResultsUpdater=self;
    self.searchcontroller.dimsBackgroundDuringPresentation = NO;
    self.searchcontroller.hidesNavigationBarDuringPresentation=NO;
    [self.searchcontroller.searchBar sizeToFit];
    self.searchcontroller.searchBar.showsCancelButton=NO;
    [self.viewbar addSubview: self.searchcontroller.searchBar];
    self.searchcontroller.searchBar.backgroundColor=[UIColor redColor];
   
    [self.tableview setSeparatorInset:UIEdgeInsetsMake(0, 10, -5, 0)];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
        //[self.navigationController setTitle:@"用户列表"];
    NSString *string=@"用户列表";
    
    NSMutableAttributedString *atributestr=[[NSMutableAttributedString alloc]initWithString:string];
    [atributestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 4)];
    self.title=string;
    //self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeron) userInfo:nil repeats:NO];
   
           // Do any additional setup after loading the view.
}


-(void)getdataToreloa{
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
            [HNProgresshud hideHudWithView:self.view];
        });
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //[HNProgresshud showHudWithView:self.view];
//        
//        [self.tableview reloadData];
//        [HNProgresshud hideHudWithView:self.view];
//    });

}

//-(void)timeron
//{
//    NSLog(@"555555555555555555555");
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //[HNProgresshud showHudWithView:self.view];
//
//        
//        [self.tableview reloadData];
//        [HNProgresshud hideHudWithView:self.view];
//    });
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ix +=1;
    //[HNProgresshud showHudWithView:self.view];
    if (ix<2) {
        [HNProgresshud showHudWithView:self.view];
    }
    

    __weak typeof(self)weakSelf = self;
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        //[SVProgressHUD showWithStatus:@"Get users"];
        
        // Load files
        //
        [weakSelf.paginator fetchFirstPage];
    });

    NSLog(@"66666666666666666");

    [self.tableview reloadData];
}


-(void)rejectaddfriend
{
    [[QBChat instance] rejectAddContactRequest:self.addid completion:^(NSError * _Nullable error) {
        
    }];
    self.conformView.hidden=YES;
}

-(void)addfriend
{
    [[QBChat instance] confirmAddContactRequest:self.addid completion:^(NSError * _Nullable error) {
        
    }];
    self.conformView.hidden=YES;
    [[HNUserManager shareInterface] getcontaclistFromeUsercontact];
}


-(void)addContact:(UIButton *)sender
{
    QBUUser *user=[HNUserManager shareInterface].notfriendsList[sender.tag];
    
    [[QBChat instance] addUserToContactListRequest:user.ID completion:^(NSError * _Nullable error) {
        
    }];
    
}

-(void)chatDidReceiveContactAddRequestFromUser:(NSUInteger)userID
{
    self.conformView.hidden=NO;
    self.addid=userID;
    
}

-(void)logInChatWithUser
{
    
}


#pragma mark  HNUSERSCHECK
-(void)checkusersAndUpdatetable
{
    NSLog(@"777777777777777777777777777");

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });

}

-(HNTableView *)tableview
{
    if (!_tableview) {
        _tableview=[[HNTableView alloc]init];
    }
    return _tableview;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableview.frame=CGRectMake(0, HNTopHeightForRegist+20, self.view.frame.size.width, self.view.frame.size.height-HNTopHeightForRegist-20);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.searchcontroller.active) {
        self.searchcontroller.active = NO;
        [self.searchcontroller.searchBar removeFromSuperview];
    }


    

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.searchcontroller.active) {
      return   self.arrsearch.count;
    }else
    {
        return [HNUserManager shareInterface].notfriendsList.count;
        

    }

    return [HNUserManager shareInterface].notfriendsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"identifier";

    HNTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[HNTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (!self.searchcontroller.active) {
        cell.avatar.image=[UIImage imageNamed:@"placeholder_regular"];
        if ([HNUserManager shareInterface].notfriendsList.count>0) {
            QBUUser *user= [HNUserManager shareInterface].notfriendsList[indexPath.row];
            cell.lable.text=user.email;
            
        }
        [cell.addBtn addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
        cell.addBtn.tag=indexPath.row;

    }else{
        if (self.arrsearch.count>0) {
            cell.avatar.image=[UIImage imageNamed:@"placeholder_regular"];
            QBUUser *user= self.arrsearch[indexPath.row];
            
            cell.lable.text=user.email;
            [cell.addBtn addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
            cell.addBtn.tag=indexPath.row;
        }
    }
    

   
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}




//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row>=0) {
//        HNVedioViewController *vc=[[HNVedioViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:NO];
//        
//    }
//}
#pragma mark search
-(void)updateSearchResultsForSearchController:(UISearchController *)searchControlle{
    NSPredicate *searchpredicate=[NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",self.searchcontroller.searchBar.text];
    NSArray *arremails=[[HNUserManager shareInterface] emailsWithUsers:[HNUserManager shareInterface].userslist];
    NSArray *arr=[arremails
                  filteredArrayUsingPredicate:searchpredicate];
    [self.arrsearch removeAllObjects];
    for (NSString *email in arr) {
       QBUUser *user= [[HNUserManager shareInterface] userWithEmail:email];
        [self.arrsearch addObject:user];

    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    NSLog(@"88888888888888888888888888");

    [[HNUserManager shareInterface].userslist addObjectsFromArray:results];
    NSLog(@"userslist:\n%@",[HNUserManager shareInterface].userslist);
    
    
    //                if (users.count>0) {
    //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HNUSERSCHECK" object:nil userInfo:nil];
    //                }
    
    
    
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObjectsFromArray:[QBChat instance].contactList.contacts];
    [arr addObjectsFromArray:[QBChat instance].contactList.pendingApproval];
    // NSLog(@"[QBChat instance].contactList.contacts]%@ arr%@",[QBChat instance].contactList.contacts,arr);
    NSMutableArray *arrid=[NSMutableArray array];
    for (QBContactListItem *item in arr) {
        [arrid addObject:[NSString stringWithFormat:@"%lu",(unsigned long)item.userID]];
    }
    
    QBGeneralResponsePage *page2=[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:20];
  // __block __weak typeof(self)weakSelf = self;

    [QBRequest usersWithIDs:arrid page:page2 successBlock:^(QBResponse * _Nonnull response, QBGeneralResponsePage * _Nullable page, NSArray<QBUUser *> * _Nullable users) {
        //NSLog(@"users::%@:%@::::::%@",response,users,page);
        [[HNUserManager shareInterface].contactList removeAllObjects];
        [[HNUserManager shareInterface].contactList addObjectsFromArray:users];
        NSMutableArray *arr=[NSMutableArray array];
        [arr addObjectsFromArray:[HNUserManager shareInterface].userslist];
        
        for (QBUUser *frieds in [HNUserManager shareInterface].contactList){
            if ([arr containsObject:frieds]) {
                [arr removeObject:frieds];
            }
        }
        [[HNUserManager shareInterface].notfriendsList removeAllObjects];
        [[HNUserManager shareInterface].notfriendsList addObjectsFromArray:arr];
        [[HNUserManager shareInterface].notfriendsList removeObject:[QBChat instance].currentUser];
        
 //        [self.tableview reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETNOTFRIEDS" object:nil];
        
//                dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"999999999999999999999999");
//            [weakSelf.tableview reloadData];
//            [HNProgresshud hideHudWithView:self.view];
//        });
//

        
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        
    }];

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableview reloadData];
//        [HNProgresshud hideHudWithView:self.view];
//    });

    // update tableview footer
    
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableview reloadData];
}


@end
