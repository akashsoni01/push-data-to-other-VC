//
//  HomeTileViewController.m
//  Insurance App
//
//  Created by Sushruth M on 21/08/15.
//  Copyright (c) 2015 Kunal Khanna. All rights reserved.
//

#import "HomeTileViewController.h"
#import "HomeViewController.h"
#import "EnrollVC.h"
#import "AccountVC.h"
#import "AssisterSearchListViewController.h"
#import "ProofScreenViewController.h"
#import "Insurance_App-Swift.h"
#import "FactoryDelegationManager.h"
#import "ChatProtocols.h"
#import "NewFamilyVC.h"
#import "ShowSiteVC.h"
#import "CustomAlertPopupViewController.h"
#import "NCNotificationManager.h"
#import "VRMainViewController.h"

@interface HomeTileViewController (){
    BOOL uiSetupForActivationAlreadyDone;
}
@property (nonatomic, assign) BOOL isChatCellClicked;
@property (weak, nonatomic) IBOutlet UILabel *lblEnrollOrNotice;

@end

@implementation HomeTileViewController
- (IBAction)testingViewControllerMove:(UIButton *)sender {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization'
        
        self.isChatCellClicked = NO;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kEvent1];
    
    if(([[dic objectForKey:kEvent1showPopUp] isEqualToString: @"true"])
       && ([[dic objectForKey:kEvent1VC] isEqualToString:@"familyVC"] || ([[dic objectForKey:kEvent1VC] isEqualToString:@"familyVC~ipad"])) && ![Utils isPushNotificationOn]){
        if([[NSUserDefaults standardUserDefaults] boolForKey:kIsAuthenticate]){
            [Utils callUserPrefScreen:self withLoginStatus:YES];
        }
        else{
            [Utils callUserPrefScreen:self withLoginStatus:NO];
            
        }
    }
    if (_isPushNewFamilyVC) {
        _isPushNewFamilyVC = false;
        NSString *nibName = (IS_IPAD)?@"NewFamilyVC~ipad":@"NewFamilyVC";
        NewFamilyVC *object=[[NewFamilyVC alloc]initWithNibName:nibName bundle:nil];
        [self.navigationController pushViewController:object animated: NO];
    }
    // Do any additional setup after loading the view.
    _viewActionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _viewActionSheet.hidden = YES;
    _actionSheetContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 737, kScreenWidth, 287)];
    _callAccessHealthLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 754, 505, 34)];
    _callAccessHealthLabel.numberOfLines = 2;
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(22, 921, 725, 73)];
    _okButton = [[UIButton alloc] initWithFrame:CGRectMake(22, 813, 725, 73)];
    [_okButton setTitle:CustomLocalisedString(@"OK", nil) forState:UIControlStateNormal];
    [_okButton addTarget:self action:@selector(btncleardata:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitle:CustomLocalisedString(@"kCancel",nil) forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(btncancel:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [_okButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [_viewActionSheet addSubview:_actionSheetContainerView];
    [_viewActionSheet addSubview:_callAccessHealthLabel];
    [_viewActionSheet addSubview:_cancelButton];
    [_viewActionSheet addSubview:_okButton];
    float fontSize = 0.0f;
    if(kScreenWidth>320)
        fontSize = 20.0f;
    else
        fontSize = 13.0f;
    
    NSString *str1 = [NSString stringWithFormat:CustomLocalisedString(@"kCallAt",nil),CustomLocalisedString(@"kHealthExchange", nil)];
    NSString *str2 = CustomLocalisedString(@"kHealthExchangeNumber",nil) ;
    
    NSMutableAttributedString *stringText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@?",str1,str2]];
    
    
    [stringText addAttribute: NSFontAttributeName value: [UIFont fontWithName:@"Helvetica-Bold" size:fontSize] range: NSMakeRange(0, [stringText length])];
    [stringText addAttribute: NSForegroundColorAttributeName value: kColorDarkGray range: NSMakeRange(0, [stringText length])];
    
    
    [stringText addAttribute: NSForegroundColorAttributeName value: [AppTheme colorForTextDark] range: NSMakeRange([str1 length], [str2 length])];
    
    _callAccessHealthLabel.attributedText = stringText;
    
    _actionSheetContainerView.layer.cornerRadius=5;
    _okButton.layer.cornerRadius=5;
    _cancelButton.layer.cornerRadius=5;
    
    _actionSheetContainerView.backgroundColor =[AppTheme colorCreamForBackground];
    _okButton.backgroundColor= [AppTheme colorForButtonBackgroundDark];
    _cancelButton.backgroundColor = [AppTheme colorForButtonBackground];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_viewActionSheet];
    
    // top header view for maryland
    
    _viewTopHeader.backgroundColor=[AppTheme colorCreamForBackground];
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //    [ChatDataManager sharedInstance].delegate = self;
    _viewActionSheet.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    if (IS_IPAD) {
        _actionSheetContainerView.frame = CGRectMake(0, 737, kScreenWidth, 287);
        _callAccessHealthLabel.frame = CGRectMake(100, 754, 650, 34);
        _cancelButton.frame = CGRectMake(22, 921, 725, 73);
        _okButton.frame = CGRectMake(22, 813, 725, 73);
    } else {
        _actionSheetContainerView.frame = CGRectMake(0, 398, kScreenWidth, 170);
        _callAccessHealthLabel.frame = CGRectMake(27, 406, 274, 39);
        _cancelButton.frame = CGRectMake(15, 520, 291, 33);
        _okButton.frame = CGRectMake(15, 463, 291, 33);
    }
    CGRect fram1 = _viewActionSheet.frame;
    fram1.origin.y = [UIScreen mainScreen].bounds.size.height;;
    _viewActionSheet.frame=fram1;
    
    _viewActionSheet.hidden = false;
    if (_viewActionSheet.tag == 55) {
        [self callActionSheetforContactus];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isPushNewFamilyVC) {
        _isPushNewFamilyVC = false;
        NSString *nibName = (IS_IPAD)?@"NewFamilyVC~ipad":@"NewFamilyVC";
        NewFamilyVC *object=[[NewFamilyVC alloc]initWithNibName:nibName bundle:nil];
        [self.navigationController pushViewController:object animated: NO];
    }
    uiSetupForActivationAlreadyDone = false;
    
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    
    //Google Analytics Check--
    [CDataManager googleAnalyticsViewController:self screenTitle:KGAHomeScreen];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorForActivationServiceHit) name:kNotificationAppActiveForActivationService object:nil];
    
    _lblShopForPlans.text   =   CustomLocalisedString(@"kGetEstimate",nil);
    _lblInformation.text    =   CustomLocalisedString(@"kInformation",nil );
    _lblgetHelp.text        =   CustomLocalisedString(@"kGetHelp",nil );
    _lblSubmitVerific.text  =   CustomLocalisedString(@"kSubmitVerific", nil);
    _lblInbox.text          =   CustomLocalisedString(@"kAccountLogin",nil);
    _lblFindAndVideoChat.text = CustomLocalisedString(@"kFindAndVideoChat",nil);
    
    if(!(IS_IPAD)){
        _lblEnrollOrNotice.font    =   [UIFont fontWithName:@"Avenir-Medium" size:14.0];
        _lblShopForPlans.font   =   [UIFont fontWithName:@"Avenir-Medium" size:14.0];
        _lblInformation.font    =   [UIFont fontWithName:@"Avenir-Medium" size:14.0];
        _lblgetHelp.font    =   [UIFont fontWithName:@"Avenir-Medium" size:14.0];
        _lblSubmitVerific.font    =   [UIFont fontWithName:@"Avenir-Medium" size:14.0];
        _lblInbox.font    =   [UIFont fontWithName:@"Avenir-Medium" size:14.0];
        
    }
    
    [_bannerImageView setImage:[UIImage imageNamed:CustomLocalisedString(@"kBannerImageName", nil)]];
    
    if(!uiSetupForActivationAlreadyDone){
        [self performSelector:@selector(selectorForActivationServiceHit)];
    }
    
    
    [self chooseLanguageLink];
}


-(void)chooseLanguageLink{
    
    [_btn_selectLanguage setTitle:CustomLocalisedString(@"kHomeTileViewLanguageKey", nil) forState:UIControlStateNormal];
    [_btn_selectLanguage setTitle:CustomLocalisedString(@"kHomeTileViewLanguageKey", nil) forState:UIControlStateSelected];
    [_btn_selectLanguage setTitle:CustomLocalisedString(@"kHomeTileViewLanguageKey", nil) forState:UIControlStateHighlighted];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [ChatDataManager sharedInstance].delegate = nil;
    _viewActionSheet.hidden = true;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)selectorForActivationServiceHit{
    //Change image and text on activation service hit
    
    uiSetupForActivationAlreadyDone = true;
    
    //Change Tile Text to Enroll/Notice based on activeEnrollment Flag from service
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:kactivateEnrollment] boolValue]) {
        _lblEnrollOrNotice.text = CustomLocalisedString(@"kEnrollInCoverage", nil);
        [_enrollImage setBackgroundImage:[UIImage imageNamed:@"enroll"] forState:UIControlStateNormal];
    }else{
        _lblEnrollOrNotice.text = CustomLocalisedString(@"KViewNotices", nil);;
        [_enrollImage setBackgroundImage:[UIImage imageNamed:@"Notice"] forState:UIControlStateNormal];
    }
}

-(IBAction)tileClicked:(UIButton*)sender{
    switch (sender.tag) {
        case 3:
        {
            
//            [[JHNotificationManager sharedManager]addCustomAlertPopupViewWithHtml:CustomLocalisedString(@"kPreScreeningCustomAlertMessage", nil) addHeaderTitle:CustomLocalisedString(@"kPreScreeningCustomAlertTitle", nil) withButtonTitle1:CustomLocalisedString(@"Ok",nil ) andButtonTitle2:CustomLocalisedString(@"kCancel", nil) andDelegate:self withOutsideTapGestureRequired:NO];
//            
//            if(IS_IPAD){
//                [JHNotificationManager sharedManager].alertPopupVController.alertPopupSize = eAlertPopupSizeDefault;
//            }
//            else{
//                [JHNotificationManager sharedManager].alertPopupVController.alertPopupSize = eAlertPopupSizeSmall;
//            }
            
            [self showAlertForPrescreening];
        }
            break;
        case 4:
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:kactivateEnrollment] boolValue]){  //Enrollment is active goto -> EnrollVC
//                if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//                {
//                    EnrollVC *object=[[EnrollVC alloc]initWithNibName:@"EnrollVC~ipad" bundle:nil];
//                    [self.navigationController pushViewController:object animated:NO];
//                    //comConferenceHomeForVerificationLogin = YES;
//                }
//                else{
//                    EnrollVC *object=[[EnrollVC alloc]initWithNibName:@"EnrollVC" bundle:nil];
//                    [self.navigationController pushViewController:object animated:NO];
//                    //object.fromConferenceHomeForVerificationLogin = YES;
//                }
               
                VRMainViewController *object=[[VRMainViewController alloc]initWithNibName:@"VRMainViewController" bundle:nil];
                [self.navigationController pushViewController:object animated:NO];
                //Google Analytics--
                [CDataManager googleAnalyticsEventWithCategory:kHomeTileCategory
                                                        action:kHomeTileEnrollEvent
                                                         label:kHomeTileEnrollLabel
                                                      andValue:nil];
            }else{ //Verification is active goto -> Notice Screen (ShowSiteVC)
                
                if([[[NSUserDefaults standardUserDefaults] objectForKey:kIsAuthenticate] boolValue])
                {
                    NSArray *cookieArr = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                    if ([cookieArr count] == 0) {
                        NSString * nibName=UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?@"AccountVC~ipad":@"AccountVC";
                        AccountVC * obj=[[AccountVC alloc]initWithNibName:nibName bundle:nil];
                        obj.isFromHomeTileVC = true;
                        [self.navigationController pushViewController:obj animated:NO];
                    }else{
                        NSString * nibName=UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?@"ShowSiteVC~ipad":@"ShowSiteVC";
                        ShowSiteVC * showvc=[[ShowSiteVC alloc]initWithNibName:nibName bundle:nil];
                        showvc.selectedIndex=1;
                        showvc.strtitle= CustomLocalisedString(@"kNotices",nil);
                        [self.navigationController pushViewController:showvc animated:NO];
                    }
                }
                else
                {
                    NSString * nibName=UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?@"AccountVC~ipad":@"AccountVC";
                    AccountVC * obj=[[AccountVC alloc]initWithNibName:nibName bundle:nil];
                    //obj.fromCompletePlanPurchase = false;
                    obj.isFromHomeTileVC = true;
                    [self.navigationController pushViewController:obj animated:NO];
                }
                
                //Google Analytics--
                [CDataManager googleAnalyticsEventWithCategory:kHomeTileCategory
                                                        action:kHomeTileNoticeEvent
                                                         label:kHomeTileNoticeLabel
                                                      andValue:nil];
                
            }
            
        }
                       break;
        case 5:
        {
            if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                AccountVC *object=[[AccountVC alloc]initWithNibName:@"AccountVC~ipad" bundle:nil];
                [self.navigationController pushViewController:object animated:NO];
            }
            else{
                AccountVC *object=[[AccountVC alloc]initWithNibName:@"AccountVC" bundle:nil];
                [self.navigationController pushViewController:object animated:NO];
            }
            
            //Google Analytics--
            [CDataManager googleAnalyticsEventWithCategory:kHomeTileCategory
                                                    action:kHomeTileInboxEvent
                                                     label:kHomeTileInboxLabel
                                                     andValue:nil];
        }
            break;
        case 6:
        {
            //Enrollment is active goto -> verification screen via AccountVC
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:kactivateEnrollment] boolValue]) {
                
                if([[[NSUserDefaults standardUserDefaults] objectForKey:kIsAuthenticate] boolValue])
                {
                    NSArray *cookieArr = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                    if ([cookieArr count] == 0) {
                        NSString * nibName=UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?@"AccountVC~ipad":@"AccountVC";
                        AccountVC * obj=[[AccountVC alloc]initWithNibName:nibName bundle:nil];
                        obj.isFromHomeTileVC = true;
                        obj.needToPushToVerificationScreen = true;
                        [self.navigationController pushViewController:obj animated:NO];
                    }else{
                        if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            ProofScreenViewController *object = [[ProofScreenViewController alloc] initWithNibName:@"ProofScreenViewController~ipad" bundle:nil];
                            object.selectedTab = eSelectedTabEnroll;
                            object.previousView = @"ConferenceHomeView";
                            [self.navigationController pushViewController:object animated:NO];
                        }
                        else {
                            ProofScreenViewController *object = [[ProofScreenViewController alloc] initWithNibName:@"ProofScreenViewController" bundle:nil];
                            object.previousView = @"ConferenceHomeView";
                            object.selectedTab = eSelectedTabEnroll;
                            [self.navigationController pushViewController:object animated:NO];
                        }

                    }
                }
                else
                {
                    NSString * nibName=UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?@"AccountVC~ipad":@"AccountVC";
                    AccountVC * obj=[[AccountVC alloc]initWithNibName:nibName bundle:nil];
                    //obj.fromCompletePlanPurchase = false;
                    obj.isFromHomeTileVC = true;
                    obj.needToPushToVerificationScreen = true;
                    [self.navigationController pushViewController:obj animated:NO];
                }
                
                //Google Analytics--
                [CDataManager googleAnalyticsEventWithCategory:kHomeTileCategory
                                                        action:kHomeTileVerificationEvent
                                                         label:kHomeTileVerificationLabel
                                                      andValue:nil];
 
            }else{ //verification is active goto -> verification screen via EnrollVC
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                NSString *isLoggedIn = [pref objectForKey:kIsAuthenticate];
                NSArray *cookieArr = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                if (isLoggedIn.boolValue ) {
                    if ([cookieArr count] == 0) {
                        if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        {
                            EnrollVC *object=[[EnrollVC alloc]initWithNibName:@"EnrollVC~ipad" bundle:nil];
                            [self.navigationController pushViewController:object animated:NO];
                            //comConferenceHomeForVerificationLogin = YES;
                        }
                        else{
                            EnrollVC *object=[[EnrollVC alloc]initWithNibName:@"EnrollVC" bundle:nil];
                            [self.navigationController pushViewController:object animated:NO];
                            //object.fromConferenceHomeForVerificationLogin = YES;
                        }
                    }else{
                        if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            ProofScreenViewController *object = [[ProofScreenViewController alloc] initWithNibName:@"ProofScreenViewController~ipad" bundle:nil];
                            object.selectedTab = eSelectedTabEnroll;
                            object.previousView = @"ConferenceHomeView";
                            [self.navigationController pushViewController:object animated:NO];
                        }
                        else {
                            ProofScreenViewController *object = [[ProofScreenViewController alloc] initWithNibName:@"ProofScreenViewController" bundle:nil];
                            object.previousView = @"ConferenceHomeView";
                            object.selectedTab = eSelectedTabEnroll;
                            [self.navigationController pushViewController:object animated:NO];
                        }
                    }
                    
                }
                else{
                    if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        EnrollVC *object=[[EnrollVC alloc]initWithNibName:@"EnrollVC~ipad" bundle:nil];
                        [self.navigationController pushViewController:object animated:NO];
                        //comConferenceHomeForVerificationLogin = YES;
                    }
                    else{
                        EnrollVC *object=[[EnrollVC alloc]initWithNibName:@"EnrollVC" bundle:nil];
                        [self.navigationController pushViewController:object animated:NO];
                        //object.fromConferenceHomeForVerificationLogin = YES;
                    }
                }
                
                //Google Analytics--
                [CDataManager googleAnalyticsEventWithCategory:kHomeTileCategory
                                                        action:kHomeTileVerificationEvent
                                                         label:kHomeTileVerificationLabel
                                                      andValue:nil];
                
            }
        }
            break;
        case 7:
        {
            //[self callActionSheetforContactus];
            [self goToAssisterSearch];
            //Google Analytics--
            [CDataManager googleAnalyticsEventWithCategory:kHomeTileCategory
                                                    action:kHomeTileContactUsEvent
                                                     label:kHomeTileContactUsLabel
                                                     andValue:nil];
        }
            break;
        case 8:
        {
            if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                MoreViewController *object = [[MoreViewController alloc] initWithNibName:@"MoreViewController~ipad" bundle:nil];
                [self.navigationController pushViewController:object animated:NO];
            }
            else{
                MoreViewController *object = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
                [self.navigationController pushViewController:object animated:NO];
                
            }
            
            //Google Analytics--
            [CDataManager googleAnalyticsEventWithCategory:kHomeTileCategory
                                                    action:kHomeTileInformationEvent
                                                     label:kHomeTileInformationLabel
                                                     andValue:nil];
        }
            break;
        default:
            break;
    }
}


-(void)goToAssisterSearch
{

    AssisterSearchListViewController *searchList = [[AssisterSearchListViewController alloc] initWithNibName:@"AssisterSearchListViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:searchList animated:YES];
}

- (IBAction)btncancel:(id)sender
{
    [self callActionSheetforContactus];
}

- (IBAction)btncleardata:(id)sender
{
    [self callActionSheetforContactus];
//    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
//    {
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", kHealthExchangeNumber]];
//        [[UIApplication sharedApplication] openURL:url];
//    }
//    else
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@" Your device does not have the facility to make phone calls." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
    if ([super canDevicePlaceAPhoneCall]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", CustomLocalisedString(@"kHealthExchangeNumber", nil)]];
        [[UIApplication sharedApplication] openURL:url];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"kNoFacilityForDeviceToMakeCall", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(void)callActionSheetforContactus
{
    
    //Delete Data
    
    [UIView animateWithDuration:0.4 animations:^{
        
        float winHeight = [UIScreen mainScreen].bounds.size.height;
        
        if(_viewActionSheet.tag !=55)
        {
            _viewActionSheet.frame = CGRectMake(0, winHeight-_viewActionSheet.frame.size.height,
                                                _viewActionSheet.frame.size.width, _viewActionSheet.frame.size.height);
            
            _viewActionSheet.tag=55;
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                for (UIView * sv in self.view.subviews) {
                    if(sv.tag == 0) {
                        CGRect temp = sv.frame;
                        temp.origin.y -= 100;
                        sv.frame = temp;
                    }
                }
            }
            [self.view viewWithTag:777].hidden=NO;
        }
        else
        {
            _viewActionSheet.frame = CGRectMake(0, winHeight,  _viewActionSheet.frame.size.width,
                                                _viewActionSheet.frame.size.height);
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                for (UIView * sv in self.view.subviews) {
                    if(sv.tag == 0) {
                        CGRect temp = sv.frame;
                        temp.origin.y += 100;
                        sv.frame = temp;
                    }
                }
            }
            _viewActionSheet.tag=0;
            
            [self.view viewWithTag:777].hidden=YES;
        }
        
    }completion:^(BOOL finished){
        
        
    }];
    
}

#pragma mark - Module CallBack delegates -

-(void)didLoginUser:(CMUserDetail *)inUser{
    //    NSDictionary *dic = @{kmessage:CustomLocalisedString(@"MSG_PLEASE_WAIT", nil)};
    //    [[JHNotificationManager sharedManager] hideCustomActivity:dic];
    if(self.isChatCellClicked){
        [ChatNavigationManager setNavigationControllerObjectWithNavObject:self.navigationController];
        [ChatNavigationManager pushToChatModuleFromViewWithType:kViewTypeMore forConversation:nil];
    }
}

-(void)didNotLoginWithError:(NSString *)inErrorString{
    NSDictionary *dic = @{kmessage:CustomLocalisedString(@"MSG_PLEASE_WAIT", nil)};
    [[JHNotificationManager sharedManager] hideCustomActivity:dic];
    if ([inErrorString containsString:@"already logged in"]) {
        [ChatNavigationManager pushToChatModuleFromViewWithType:kViewTypeMore forConversation:nil];
    }
    else{
        UIAlertView *loginFailError= [[UIAlertView alloc] initWithTitle:CustomLocalisedString(@"kLoginFailed", nil) message:CustomLocalisedString(@"kChatLoginFailure", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"OK", nil) otherButtonTitles:nil];
        [loginFailError show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma MARK - Alert View Delegates

-(void)showAlertForPrescreening
{
    
    [[JHNotificationManager sharedManager] addCustomAlertPopupViewWithHtml:CustomLocalisedString(@"kPreScreeningCustomAlertMessage", nil)  addHeaderTitle:CustomLocalisedString(@"kPrescreenAlertTitle", nil) withButtonTitle1:CustomLocalisedString(@"kContinue", nil) andButtonTitle2:CustomLocalisedString(@"kCancel", nil) andDelegate:self withOutsideTapGestureRequired:NO];
    
    if (IS_IPAD) {
        [JHNotificationManager sharedManager].alertPopupVController.alertPopupSize = eAlertPopupSizeDefault;
    }
    else {
        [JHNotificationManager sharedManager].alertPopupVController.alertPopupSize = eAlertPopupSizeSmall;
    }
}


-(void)actionDidSelectWithActionType:(enCustomAlertPopupAction)inActionType
{
    
    if (inActionType == eActionOnOk)
    {
        if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            NSString *StrNibName = @"NewFamilyVC~ipad";
            NewFamilyVC *object = [[NewFamilyVC alloc] initWithNibName:StrNibName bundle:nil];
            [self.navigationController pushViewController:object animated:YES];
        }
        else{
            NSString *StrNibName = @"NewFamilyVC";//= IS_IPHONE_5?@"HomeViewController~iphone5":@"HomeViewController12";
            NewFamilyVC *object = [[NewFamilyVC alloc] initWithNibName:StrNibName bundle:nil];
            [self.navigationController pushViewController:object animated:YES];
        }
        
        //Google Analytics--
        [CDataManager googleAnalyticsEventWithCategory:kHomeTileCategory
                                                action:kHomeTileShopForPlanEvent
                                                 label:kHomeTileShopForPlanLabel
                                              andValue:nil];
        
    }
    
}

//Language Button Action
- (IBAction)selectLanguageClicked:(id)sender {
    [self.view endEditing:YES];
    
    NSString *currentLanguage = [self getLanguageButtonTitle];
    NSInteger index=0;
    
    
    if([currentLanguage caseInsensitiveCompare:CustomLocalisedString(@"kEnglish", nil)] == NSOrderedSame)
    {
        index=2;
        
    }
    else if([currentLanguage caseInsensitiveCompare:CustomLocalisedString(@"kSpanish", nil)] == NSOrderedSame)
    {
       
        index=1;
        
    }
    
    LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
    Locale *localeForRow = languageManager.availableLocales[index];
    [MoreViewController setLanguageChangedFromApp:localeForRow];
    [languageManager setLanguageWithLocale:localeForRow];
    [languageManager setLanguageChangedFromApp:YES];
    
    if (gDataManager.isLanguageChangedFromMore) {
        [[NCNotificationManager sharedInstance] enableSNSPushForUserId];
    }
    [self viewWillAppear:YES];
    [Utils hitActivationServiceForViewController:self];
}

-(NSString *) getLanguageButtonTitle {
    
    NSString *currentLanguage;
    
    if([@"es" caseInsensitiveCompare:[[LanguageManager sharedLanguageManager] getCurrentLanguage]] == NSOrderedSame) {
        
        currentLanguage = CustomLocalisedString(@"kSpanish", nil);
    } else {
        
        currentLanguage = CustomLocalisedString(@"kEnglish", nil);
    }
    
    return currentLanguage;
}

#pragma mark - Orientation handling -

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


//#pragma mark - custom alert delegates
//-(void)actionDidSelectWithActionType:(enCustomAlertPopupAction)inActionType{
//    if(inActionType == eActionOnOk){
//    
//        
//    
//    }
//}
@end
