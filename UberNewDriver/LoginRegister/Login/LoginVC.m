//
//  LoginVC.m
//  UberNewDriver
//
//  Created by Deep Gami on 27/09/14.
//  Copyright (c) 2014 Deep Gami. All rights reserved.
//

#import "LoginVC.h"
#import "FacebookUtility.h"
#import <GooglePlus/GooglePlus.h>
#import "GooglePlusUtility.h"
#import "UIImageView+Download.h"
#import "AppDelegate.h"
#import "RMMapper.h"
#import "RMUser.h"
#import "RMUserDetails.h"
//#import "Mysingletonclass.h"
#import "cntylistTableViewCell.h"

@interface LoginVC ()<UNUserNotificationCenterDelegate>
{
    AppDelegate *appDelegate;
    BOOL internet;
    NSMutableDictionary *dictparam;
    
    NSString * strEmail;
    NSString * strPassword;
    NSString * strLogin;
    NSMutableString * strSocialId;
    NSUserDefaults *prefl;
    NSUserDefaults *pref;

    NSMutableArray *arrForCountry;
    NSMutableArray *arrForCountryphonecode;
    NSMutableArray *arrForCountryname;

    NSString *loginmethod;
}


@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark - View Life Cycle

@synthesize txtPassword,txtEmail;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setBackBarItem];
    prefl = [[NSUserDefaults alloc]init];
    //NSLog(@"fonts: %@", [UIFont familyNames]);
    
    //txtEmail.text=@"nirav.kotecha99@gmail.com";
    //txtPassword.text=@"123456";
    dictparam=[[NSMutableDictionary alloc]init];
    pref=[NSUserDefaults standardUserDefaults];
    strEmail=[pref objectForKey:PREF_EMAIL];
    strPassword=[pref objectForKey:PREF_PASSWORD];
    strLogin=[pref objectForKey:PREF_LOGIN_BY];
    strSocialId=[pref objectForKey:PREF_SOCIAL_ID];

    internet=[APPDELEGATE connected];
    
    if(strEmail!=nil)
    {
        [self getSignIn];
    }
    
    [self customFont];
    
   
    
    //self.txtEmail.placeholder
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self customFont];
    self.navigationController.navigationBarHidden=NO;
    [self.btnSignUp setTitle:NSLocalizedStringFromTable(@"Sign In",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self customFont];
    [self.btnSignUp setTitle:NSLocalizedStringFromTable(@"Sign In",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
}

-(void)customFont
{
    self.txtEmail.font=[UberStyleGuide fontRegular];
    self.txtPassword.font=[UberStyleGuide fontRegular];
    self.btnSignUp.titleLabel.textColor = [UberStyleGuide colorDefault];
    self.btnForgotPsw.titleLabel.textColor = [UberStyleGuide colorDefault];
    self.btnForgotPsw.titleLabel.font = [UberStyleGuide fontRegularBold];
    self.btnSignIn.titleLabel.font = [UberStyleGuide fontRegularBold];
    self.btnSignUp.titleLabel.font = [UberStyleGuide fontRegularBold];
    [self.btnSignIn setTitle:NSLocalizedStringFromTable(@"SIGN IN",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
    [self.btnForgotPsw setTitle:NSLocalizedStringFromTable(@"FORGOT_PASSWORD",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    self.txtEmail.placeholder = NSLocalizedStringFromTable(@"EMAILP",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtPassword.placeholder = NSLocalizedStringFromTable(@"PASSWORD",[prefl objectForKey:@"TranslationDocumentName"],nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Sign In

-(void)getSignIn
{
    @try
    {
        pref=[NSUserDefaults standardUserDefaults];
        if (strEmail==nil)
        {
            strEmail=[pref objectForKey:PREF_EMAIL];
            strPassword=[pref objectForKey:PREF_PASSWORD];
            strLogin=[pref objectForKey:PREF_LOGIN_BY];
            strSocialId=[pref objectForKey:PREF_SOCIAL_ID];
        }
        if([APPDELEGATE connected])
        {
            [APPDELEGATE showLoadingWithTitle:NSLocalizedStringFromTable(@"LOADING",[prefl objectForKey:@"TranslationDocumentName"], nil)];
            NSString *strDeviceId=[pref objectForKey:[NSString stringWithFormat:@"%@",PREF_DEVICE_TOKEN]];
            NSLog(@"Value-%@",strDeviceId);
            [dictparam setObject:strDeviceId forKey:@"device_token"];
            [dictparam setObject:@"ios" forKey:PARAM_DEVICE_TYPE];
            NSString *useremailphone;
            if([loginmethod isEqual:@"mobile"])
            {
                NSString *mobno= [NSString stringWithFormat:@"%@%@",self.countrycodebtn.titleLabel.text, self.txtEmail.text];
                useremailphone=mobno;
            }
            else
            {
                NSString *mobno= self.txtEmail.text;
                useremailphone=mobno;
            }
            [dictparam setObject:useremailphone forKey:PARAM_EMAIL];
            [dictparam setObject:strLogin forKey:PARAM_LOGIN_BY];
            if (![strLogin isEqualToString:@"manual"])
            {
                [dictparam setObject:strSocialId forKey:PARAM_SOCIAL_ID];
            }
            else
            {
                [dictparam setObject:strPassword forKey:PARAM_PASSWORD];
            }
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_LOGIN withParamData:dictparam withBlock:^(id response, NSError *error)
             {
                 NSLog(@"Res- %@",response);
                 NSLog(@"Testresp %@",[[response valueForKey:@"driver"] valueForKey:@"id"]);
                 NSLog(@"Loginbystring %@",[[response valueForKey:@"driver"] valueForKey:@"login_by"]);
                 if (response)
                 {
                     if([[response valueForKey:@"success"] intValue]==1)
                     {
                         NSLog(@"Res- %@",response);
                         NSDictionary *set = response;
                         RMUserDetails *getrooms = [RMMapper objectWithClass:[RMUserDetails class] fromDictionary:set];
                         NSDictionary *getDict = (NSDictionary *) getrooms.driver;
                         RMUser *getUser = [RMMapper objectWithClass:[RMUser class] fromDictionary:getDict];
                         NSLog(@"GetDate: %@",getUser.id);

                         NSString *Loginbystr =[[response valueForKey:@"driver"] valueForKey:@"login_by"];
                         arrUser=[response valueForKey:@"driver"];
                         NSLog(@"GetData: %@",arrUser);
                         pref=[NSUserDefaults standardUserDefaults];
                         [pref setObject:Loginbystr forKey:@"LoginByString"];
                         [pref setObject:getUser.token forKey:PREF_USER_TOKEN];
                         [pref setObject:getUser.id forKey:PREF_USER_ID];
                         [pref setObject:[NSString stringWithFormat:@"%@",strDeviceId] forKey:PREF_DEVICE_TOKEN];
                         [pref setObject:getUser.login_by forKey:PREF_LOGIN_BY];
                         [pref setObject:txtEmail.text forKey:PREF_EMAIL];
                         [pref setObject:txtPassword.text forKey:PREF_PASSWORD];
                         [pref setObject:@"manual" forKey:PREF_LOGIN_BY];
                         [pref setBool:YES forKey:PREF_IS_LOGIN];
                         [pref setObject:getUser.is_approved forKey:PREF_IS_APPROVED];
                         [pref synchronize];
                         txtPassword.userInteractionEnabled=YES;
                         [APPDELEGATE hideLoadingView];
                         [APPDELEGATE showToastMessage:(NSLocalizedStringFromTable(@"SIGING_SUCCESS",[prefl objectForKey:@"TranslationDocumentName"], nil))];
                         [self performSegueWithIdentifier:@"seguetopickme" sender:self];
                     }
                     else
                     {
                         UIAlertController * alert=[UIAlertController alertControllerWithTitle:@""
                                                                                               message:[response valueForKey:@"error"]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];

                         UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                                style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action)
                                                        {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                        }];
                         [alert addAction:cancelButton];
                         [self presentViewController:alert animated:YES completion:nil];
                     }
                 }
                 [APPDELEGATE hideLoadingView];
                 NSLog(@"REGISTER RESPONSE --> %@",response);
             }];
        }
        else
        {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"No Internet",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                          message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action)
                                           {
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                           }];
            [alert addAction:cancelButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}

#pragma mark -
#pragma mark - Button Action

- (IBAction)onClickSignIn:(id)sender
{
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications])
    {
        @try
        {
            [txtEmail resignFirstResponder];
            [txtPassword resignFirstResponder];
            
            strEmail=self.txtEmail.text;
            strPassword=self.txtPassword.text;
            strLogin=@"manual";
            [self getSignIn];
        }
        @catch (NSException *exception)
        {
            
        }
        @finally
        {
            
        }
    }
    else
    {
        NSLog(@"Notification Disabled");
        UIAlertController * alertLocation=[UIAlertController alertControllerWithTitle:@""
                                                                      message:@"Please Enable Push Notification access from Settings -> JayeenTaxi Driver -> Privacy -> Push Notification services"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alertLocation dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alertLocation addAction:cancelButton];
        [self presentViewController:alertLocation animated:YES completion:nil];

        return;
    }
}


#pragma mark - Navigation

- (IBAction)googleBtnPressed:(id)sender
{
    [APPDELEGATE showLoadingWithTitle:@"Please Wait"];
    if([APPDELEGATE connected])
    {
        if ([[GooglePlusUtility sharedObject]isLogin])
        {
            [APPDELEGATE hideLoadingView];
        }
        else
        {
            [[GooglePlusUtility sharedObject]loginWithBlock:^(id response, NSError *error)
             {
                 [APPDELEGATE hideLoadingView];
                 if (response) {
                     NSLog(@"Response ->%@ ",response);
                     txtPassword.userInteractionEnabled=NO;
                     self.txtEmail.text=[response valueForKey:@"email"];
                     
                     pref=[NSUserDefaults standardUserDefaults];
                     [pref setObject:txtEmail.text forKey:PREF_EMAIL];
                     [pref setObject:@"google" forKey:PREF_LOGIN_BY];
                     [pref setObject:[response valueForKey:@"userid"] forKey:PREF_SOCIAL_ID];
                     [pref setBool:YES forKey:PREF_IS_LOGIN];
                     [pref synchronize];
                     [self getSignIn];
                 }
             }];
        }
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"No Internet",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                      message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)facebookBtnPressed:(id)sender
{
    [APPDELEGATE showLoadingWithTitle:@"Please wait"];
    if([APPDELEGATE connected])
    {
        if (![[FacebookUtility sharedObject]isLogin])
        {
            [[FacebookUtility sharedObject]loginInFacebook:^(BOOL success, NSError *error)
             {
                 [APPDELEGATE hideLoadingView];
                 if (success)
                 {
                     NSLog(@"Success");
                     appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                     [appDelegate userLoggedIn];
                     [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
                         if (response) {
                             NSLog(@"%@",response);
                             self.txtEmail.text=[response valueForKey:@"email"];
                             
                             txtPassword.userInteractionEnabled=NO;
                             txtPassword.text=@"";
                                                          
                             
                             pref=[NSUserDefaults standardUserDefaults];
                             [pref setObject:[response valueForKey:@"email"] forKey:PREF_EMAIL];
                             [pref setObject:@"facebook" forKey:PREF_LOGIN_BY];
                             [pref setObject:[response valueForKey:@"id"] forKey:PREF_SOCIAL_ID];
                             [pref setBool:YES forKey:PREF_IS_LOGIN];
                             [pref synchronize];
                             
                             [self getSignIn];
                             
                         }
                     }];
                 }
             }];
        }
        else{
            NSLog(@"User Login Click");
            appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
                [APPDELEGATE hideLoadingView];

                if (response) {
                    NSLog(@"%@",response);
                    NSLog(@"%@",response);
                    self.txtEmail.text=[response valueForKey:@"email"];
                    txtPassword.userInteractionEnabled=NO;
                    pref=[NSUserDefaults standardUserDefaults];
                    [pref setObject:[response valueForKey:@"email"] forKey:PREF_EMAIL];
                    [pref setObject:@"facebook" forKey:PREF_LOGIN_BY];
                    [pref setObject:[response valueForKey:@"id"] forKey:PREF_SOCIAL_ID];
                    [pref setBool:YES forKey:PREF_IS_LOGIN];
                    [pref synchronize];
                    [self getSignIn];
                    
                }
            }];
            [appDelegate userLoggedIn];
        }
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"No Internet",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                      message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)forgotBtnPressed:(id)sender
{
    
}

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int y=0;
    if (textField==self.txtEmail)
    {
        y=100;
    }
    else if (textField==self.txtPassword)
    {
        y=150;
    }
    [self.scrLogin setContentOffset:CGPointMake(0, y) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.txtEmail)
    {
        [self.txtPassword becomeFirstResponder];
    }
    else if (textField==self.txtPassword)
    {
        [textField resignFirstResponder];
        [self.scrLogin setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==self.txtEmail)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(newString.length==0)
        {
            self.countrycodebtn.hidden=true;
            self.txtEmail.frame=CGRectMake(self.countrycodebtn.frame.origin.x, self.txtEmail.frame.origin.y, self.txtEmail.frame.size.width,self.txtEmail.frame.size.height);
        }
        else
        {
            if(newString.length==1)
            {
                NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                if([newString stringByTrimmingCharactersInSet:nonNumberSet].length > 0)
                {
                    self.countrycodebtn.hidden=false;
                    self.txtEmail.frame=CGRectMake(self.countrycodebtn.frame.origin.x+_countrycodebtn.frame.size.width+5, self.txtEmail.frame.origin.y, self.txtEmail.frame.size.width,self.txtEmail.frame.size.height);
                    loginmethod=@"mobile";
                }
                else
                {
                    self.countrycodebtn.hidden=true;
                    self.txtEmail.frame=CGRectMake(self.countrycodebtn.frame.origin.x, self.txtEmail.frame.origin.y, self.txtEmail.frame.size.width,self.txtEmail.frame.size.height);
                    loginmethod=@"email";
                }
            }
        }
    }
    return YES;
}

#pragma mark-
#pragma mark- Table View Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  arrForCountryname.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cntylistTableViewCell *cell = (cntylistTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"countrylistcell" forIndexPath:indexPath];

    if (cell==nil)
    {
        cell=[[cntylistTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"countrylistcell"];
    }
    cell.countrycodelbl.text=[arrForCountryphonecode objectAtIndex:indexPath.row];
    cell.countrynamelbl.text=[arrForCountryname objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectcountrycodesearchview.hidden=YES;
    [self.countrycodebtn setTitle:[arrForCountryphonecode objectAtIndex:indexPath.row] forState:UIControlStateNormal];
}

# pragma mark Search Bar Delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0)
    {
        arrForCountryphonecode=[[NSMutableArray alloc]init];
        arrForCountryname=[[NSMutableArray alloc]init];
        for (NSArray *a in arrForCountry)
        {
            [arrForCountryname addObject:[a valueForKey:@"name"]];
            [arrForCountryphonecode addObject:[a valueForKey:@"phone-code"]];
        }
        if(arrForCountryname.count>0)
        {
            [self.selectcountrycodelisttbv reloadData];
        }
    }
    else
    {
        self.selectcountrycodelisttbv.hidden=false;
        NSArray *filteredData = [arrForCountry filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(name BEGINSWITH[cd] %@)", searchText]];
        NSLog(@"array filtered : %@", filteredData);
        arrForCountryphonecode=[[NSMutableArray alloc]init];
        arrForCountryname=[[NSMutableArray alloc]init];
        if(filteredData.count>0)
        {
            self.selectcountrycodelisttbv.hidden=NO;
            for (NSArray *a in filteredData)
            {
                [arrForCountryname addObject:[a valueForKey:@"name"]];
                [arrForCountryphonecode addObject:[a valueForKey:@"phone-code"]];
            }
        }
        else
        {
            self.selectcountrycodelisttbv.hidden=YES;
        }
        if(arrForCountryname.count>0)
        {
            [self.selectcountrycodelisttbv reloadData];
        }
    }
}

- (IBAction)selectCountryBtnPressed:(id)sender
{
    arrForCountryphonecode=[[NSMutableArray alloc]init];
    arrForCountryname=[[NSMutableArray alloc]init];
    arrForCountry=[[NSMutableArray alloc]init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrycodes" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    arrForCountry = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for (NSArray *a in arrForCountry)
    {
        [arrForCountryname addObject:[a valueForKey:@"name"]];
        [arrForCountryphonecode addObject:[a valueForKey:@"phone-code"]];
    }
    if(arrForCountryname.count>0)
    {
        [self.selectcountrycodelisttbv reloadData];
    }
    _srchbar.returnKeyType=UIReturnKeyDone;
    self.selectcountrycodesearchview.hidden=NO;
    [self.txtEmail resignFirstResponder];
    [self.srchbar becomeFirstResponder];
}

- (IBAction)searchBarCancelButtonClicked:(id)sender
{
    [self.srchbar resignFirstResponder];
    self.selectcountrycodesearchview.hidden=YES;
    [self.scrLogin setContentOffset:CGPointMake(0, 0) animated:YES];
}



@end
