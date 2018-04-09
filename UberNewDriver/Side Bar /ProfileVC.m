//
//  ProfileVC.m
//  UberNewDriver
//
//  Created by My mac on 11/3/14.
//  Copyright (c) 2014 Deep Gami. All rights reserved.
//

#import "ProfileVC.h"
#import "UIImageView+Download.h"
#import "UIView+Utils.h"
#import "UtilityClass.h"
#import "PickMeUpMapVC.h"
#import "ArrivedMapVC.h"
#import "FeedBackVC.h"


@interface ProfileVC ()
{
    BOOL internet;
    NSMutableString *strUserId;
    NSMutableString *strUserToken;
    NSMutableString *strPassword;
    NSUserDefaults *prefl ;
}

@end

@implementation ProfileVC

@synthesize txtAddress,title,txtBio,txtEmail,txtLastName,txtName,txtNumber,txtZip,txtPassword,btnProPic,txtNewPassword,bgNewPwd,bgPwd,txtTaxiModel,txtTaxiNumber,txtReNewPassword,bgReNewPwd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setBackBarItem];
    prefl = [[NSUserDefaults alloc]init];
    [self.profileImage applyRoundedCornersFullWithColor:[UIColor whiteColor]];
    [self.ScrollProfile setScrollEnabled:YES];
    [self.ScrollProfile setContentSize:CGSizeMake(320, 465)];
    
    [self textDisable];
    [self localizeString];
    
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    [pref synchronize];
    strUserId=[pref objectForKey:PREF_USER_ID];
    strUserToken=[pref objectForKey:PREF_USER_TOKEN];
    strPassword=[pref objectForKey:PREF_PASSWORD];
    
    [txtName setTintColor:[UIColor whiteColor]];
    [txtLastName setTintColor:[UIColor whiteColor]];
    
    txtName.text=[arrUser valueForKey:@"first_name"];
    txtLastName.text=[arrUser valueForKey:@"last_name"];
    txtEmail.text=[arrUser valueForKey:@"email"];
    txtNumber.text=[arrUser valueForKey:@"phone"];
    txtAddress.text=[arrUser valueForKey:@"address"];
    txtBio.text=[arrUser valueForKey:@"bio"];
    txtZip.text=[NSString stringWithFormat:@"%@",[arrUser valueForKey:@"zipcode"]];
    txtTaxiModel.text=[arrUser valueForKey:@"car_model"];
    txtTaxiNumber.text=[arrUser valueForKey:@"car_number"];

    txtPassword.text=@"";
    txtNewPassword.text=@"";
    txtReNewPassword.text=@"";
    
    [self.profileImage downloadFromURL:[arrUser valueForKey:@"picture"] withPlaceholder:nil];
    
    [self.btnUpdate setHidden:YES];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.lblCarModelInfo.hidden=YES;
    self.imgCarModelInfo.hidden=YES;
    self.lblCarNumberInfo.hidden=YES;
    self.imgCarNumberInfo.hidden=YES;
    self.lblEmailInfo.hidden=YES;
    self.imgEmailInfo.hidden=YES;
    self.btnInfo1.tag=0;
    self.btnInfo2.tag=0;
    self.btnInfo3.tag=0;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.btnMenu setTitle:NSLocalizedStringFromTable(@"PROFILE",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark- Custom Font

-(void)customFont
{
    self.txtName.font=[UberStyleGuide fontRegular];
    self.txtLastName.font=[UberStyleGuide fontRegular];
    self.txtEmail.font=[UberStyleGuide fontRegular];
    self.txtAddress.font=[UberStyleGuide fontRegular];
    self.txtBio.font=[UberStyleGuide fontRegular];
    self.txtZip.font=[UberStyleGuide fontRegular];
    
    self.btnMenu.titleLabel.font=[UberStyleGuide fontRegular:9.0f];
    self.btnEdit=[APPDELEGATE setBoldFontDiscriptor:self.btnEdit];
    self.btnUpdate=[APPDELEGATE setBoldFontDiscriptor:self.btnUpdate];
    
    self.btnMenu.titleLabel.textColor = [UberStyleGuide colorDefault];
    
    self.lblEmailInfo.textColor = [UberStyleGuide colorDefault];
    self.lblCarNumberInfo.textColor = [UberStyleGuide colorDefault];
    self.lblCarModelInfo.textColor = [UberStyleGuide colorDefault];
    
}

-(void)localizeString
{
    
    self.txtName.placeholder = NSLocalizedStringFromTable(@"NAME",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtLastName.placeholder = NSLocalizedStringFromTable(@"LAST NAME",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtEmail.placeholder = NSLocalizedStringFromTable(@"EMAIL",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtNumber.placeholder = NSLocalizedStringFromTable(@"NUMBER",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtAddress.placeholder = NSLocalizedStringFromTable(@"ADDRESS",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtBio.placeholder = NSLocalizedStringFromTable(@"BOI",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtPassword.placeholder = NSLocalizedStringFromTable(@"CURRENT PASSWORD",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtNewPassword.placeholder = NSLocalizedStringFromTable(@"NEW PASSWORD",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtReNewPassword.placeholder = NSLocalizedStringFromTable(@"CONFIRM NEW PASSWORD",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtZip.placeholder = NSLocalizedStringFromTable(@"ZIPCODE",[prefl objectForKey:@"TranslationDocumentName"],nil);
    
    self.txtTaxiModel.placeholder = NSLocalizedStringFromTable(@"TAXI MODEL",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtTaxiModel.placeholder = NSLocalizedStringFromTable(@"TAXI NUMBER",[prefl objectForKey:@"TranslationDocumentName"],nil);
    
    
    self.lblEmailInfo.text = NSLocalizedStringFromTable(@"This field is not editable.",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.lblCarNumberInfo.text = NSLocalizedStringFromTable(@"This field is not editable.",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.lblCarModelInfo.text = NSLocalizedStringFromTable(@"This field is not editable.",[prefl objectForKey:@"TranslationDocumentName"],nil);

    [self.btnEdit setTitle:NSLocalizedStringFromTable(@"Edit Profile",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
    //[self.btnEdit setTitle:NSLocalizedStringFromTable(@"Edit Profile",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateSelected];
    
    [self.btnUpdate setTitle:NSLocalizedStringFromTable(@"Update Profile",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
   // [self.btnUpdate setTitle:NSLocalizedStringFromTable(@"Update Profile",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateSelected];
}

#pragma mak- 
#pragma mark- TextField Enable and Disable

-(void)textDisable
{
    txtName.enabled = NO;
    txtLastName.enabled = NO;
    txtEmail.enabled = NO;
    txtNumber.enabled = NO;
    txtPassword.enabled = NO;
    txtAddress.enabled = NO;
    txtZip.enabled = NO;
    txtBio.enabled = NO;
    btnProPic.enabled=NO;
    
    txtPassword.hidden=YES;
    txtNewPassword.hidden=YES;
    txtReNewPassword.hidden=YES;
    bgPwd.hidden=YES;
    bgNewPwd.hidden=YES;
    bgReNewPwd.hidden=YES;
    //[self.ScrollProfile setScrollEnabled:NO];
    
    CGPoint offset;
    offset=CGPointMake(0, 0);
    [self.ScrollProfile setContentSize:CGSizeMake(320, 465)];
    [self.ScrollProfile setContentOffset:offset animated:YES];
}

-(void)textEnable
{
    txtName.enabled = YES;
    txtLastName.enabled = YES;
    txtEmail.enabled = NO;
    txtNumber.enabled = YES;
    txtPassword.enabled = YES;
    txtAddress.enabled = YES;
    txtZip.enabled = YES;
    txtBio.enabled = YES;
    btnProPic.enabled=YES;
    
    txtPassword.hidden=NO;
    txtNewPassword.hidden=NO;
    txtReNewPassword.hidden=NO;
    bgPwd.hidden=NO;
    bgNewPwd.hidden=NO;
    bgReNewPwd.hidden=NO;
    [self.ScrollProfile setContentSize:CGSizeMake(320, 650)];
    //[self.ScrollProfile setScrollEnabled:YES];
}


-(void)updatePRofile
{
    NSLog(@"\n\n IN Update PRofile");
    
    [APPDELEGATE showLoadingWithTitle:NSLocalizedStringFromTable(@"UPDATING_PROFILE",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    internet=[APPDELEGATE connected];
    
    if(internet)
    {
            NSMutableDictionary *dictparam;
            dictparam= [[NSMutableDictionary alloc]init];
            
            [dictparam setObject:txtName.text forKey:PARAM_FIRST_NAME];
            [dictparam setObject:txtLastName.text forKey:PARAM_LAST_NAME];
            [dictparam setObject:txtEmail.text forKey:PARAM_EMAIL];
            [dictparam setObject:txtNumber.text forKey:PARAM_PHONE];
            //[dictparam setObject:strPassword forKey:PARAM_PASSWORD];
            
            [dictparam setObject:txtPassword.text forKey:PARAM_OLDPASSWORD];
            [dictparam setObject:txtNewPassword.text forKey:PARAM_NEWPASSWORD];
            //[dictparam setObject:strPassword forKey:PARAM_PASSWORD];
            [dictparam setObject:txtAddress.text forKey:PARAM_ADDRESS];
            [dictparam setObject:txtBio.text forKey:PARAM_BIO];
            [dictparam setObject:txtZip.text forKey:PARAM_ZIPCODE];
            //[dictparam setObject:device_token forKey:PARAM_DEVICE_TOKEN];
            
            [dictparam setObject:strUserId forKey:PARAM_ID];
            [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
            
            
            
            [dictparam setObject:@"" forKey:PARAM_PICTURE];
            
            UIImage *imgUpload = [[UtilityClass sharedObject]scaleAndRotateImage:self.profileImage.image];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_UPDATE_PROFILE withParamDataImage:dictparam andImage:imgUpload withBlock:^(id response, NSError *error)
             {
                 NSLog(@"Response-52%@",response);
                  NSLog(@"Response-52%@",[response valueForKey:@"success"]);
                 NSLog(@"Response-52%@",[response valueForKey:@"first_name"]);
                 
                 if (response)
                 {
                     if([[response valueForKey:@"success"] intValue]==1)
                     {
                         NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                         [pref setObject:response forKey:PREF_LOGIN_BY];
                         arrUser=response;
                         [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"PROFILE_UPDATED",[prefl objectForKey:@"TranslationDocumentName"],nil)];
                         txtName.text=[arrUser valueForKey:@"first_name"];
                         txtLastName.text=[arrUser valueForKey:@"last_name"];
                         txtEmail.text=[arrUser valueForKey:@"email"];
                         txtNumber.text=[arrUser valueForKey:@"phone"];
                         txtAddress.text=[arrUser valueForKey:@"address"];
                         txtZip.text=[arrUser valueForKey:@"zipcode"];
                         txtBio.text=[arrUser valueForKey:@"bio"];
                         [self.profileImage downloadFromURL:[arrUser valueForKey:@"picture"] withPlaceholder:nil];
                         [self.profileImage downloadFromURL:[arrUser valueForKey:@"picture"] withPlaceholder:nil];
                     
                     }
                     else
                     {
                         UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Profile Update Fail"
                                                                                       message:[response valueForKey:@"error"]
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
                     [self.btnEdit setHidden:NO];
                     [self.btnUpdate setHidden:YES];
                     [self textDisable];
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
#pragma mark-
#pragma mark- Button Method

- (IBAction)LogOutBtnPressed:(id)sender
{
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    
    [pref synchronize];
    [pref removeObjectForKey:PARAM_REQUEST_ID];
    [pref removeObjectForKey:PARAM_SOCIAL_ID];
    [pref removeObjectForKey:PREF_EMAIL];
    [pref removeObjectForKey:PREF_LOGIN_BY];
    [pref removeObjectForKey:PREF_PASSWORD];
    [pref setBool:NO forKey:PREF_IS_LOGIN];
    
    [self.navigationController.navigationController    popToRootViewControllerAnimated:YES];
}

- (IBAction)editBtnPressed:(id)sender
{
    [self textEnable];
    [APPDELEGATE showToastMessage:@"You Can Edit Your Profile"];
    [self.btnEdit setHidden:YES];
    [self.btnUpdate setHidden:NO];
    [txtName becomeFirstResponder];
    
    
}

- (IBAction)updateBtnPressed:(id)sender
{
    internet=[APPDELEGATE connected];
    if (self.txtNewPassword.text.length>=1 || self.txtReNewPassword.text.length>=1)
    {
        if ([txtNewPassword.text isEqualToString:txtReNewPassword.text])
        {
            [self updatePRofile];
            
        }
        else
        {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Profile Update Fail"
                                                                          message:NSLocalizedStringFromTable(@"NOT_MATCH_RETYPE",[prefl objectForKey:@"TranslationDocumentName"],nil)
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
    else
    {
        [self updatePRofile];
    }
    
}

- (IBAction)backBtnPressed:(id)sender
{
    NSArray *currentControllers = self.navigationController.viewControllers;
    NSMutableArray *newControllers = [NSMutableArray
                                      arrayWithArray:currentControllers];
    UIViewController *obj=nil;
    
    for (int i=0; i<newControllers.count; i++)
    {
        UIViewController *vc=[self.navigationController.viewControllers objectAtIndex:i];
        if ([vc isKindOfClass:[FeedBackVC class]])
        {
            obj = (FeedBackVC *)vc;
        }
        else if ([vc isKindOfClass:[ArrivedMapVC class]])
        {
            obj = (ArrivedMapVC *)vc;
        }
        else if ([vc isKindOfClass:[PickMeUpMapVC class]])
        {
            obj = (PickMeUpMapVC *)vc;
        }
        
    }
    [self.navigationController popToViewController:obj animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)imgPicBtnPressed:(id)sender
{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Select Image", nil];
    action.tag=10001;
    [action showInView:self.view];
    
}


- (IBAction)onClickEmailInfo:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==0)
    {
        btn.tag=1;
        self.lblEmailInfo.hidden=NO;
        self.imgEmailInfo.hidden=NO;
    }
    else
    {
        btn.tag=0;
        self.lblEmailInfo.hidden=YES;
        self.imgEmailInfo.hidden=YES;
    }

}

- (IBAction)onClickTaxiModelInfo:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==0)
    {
        btn.tag=1;
        self.lblCarModelInfo.hidden=NO;
        self.imgCarModelInfo.hidden=NO;
    }
    else
    {
        btn.tag=0;
        self.lblCarModelInfo.hidden=YES;
        self.imgCarModelInfo.hidden=YES;
    }
}

- (IBAction)onClickTaxiNoInfo:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==0)
    {
        btn.tag=1;
        self.lblCarNumberInfo.hidden=NO;
        self.imgCarNumberInfo.hidden=NO;
    }
    else
    {
        btn.tag=0;
        self.lblCarNumberInfo.hidden=YES;
        self.imgCarNumberInfo.hidden=YES;
    }

}

#pragma mark -
#pragma mark - UIActionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self chooseFromLibaray];
            break;
        case 2:
            break;
        case 3:
            break;
    }
}

-(void)openCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate =self;
        imagePickerController.allowsEditing=YES;

        imagePickerController.view.tag = 102;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@""
                                                                      message:NSLocalizedStringFromTable(@"CAM_NOT_AVAILABLE",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)chooseFromLibaray
{
    // Set up the image picker controller and add it to the view
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate =self;
     imagePickerController.allowsEditing=YES;
    imagePickerController.view.tag = 102;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:^{
    }];
}

#pragma mark -
#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.profileImage.image=[info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-
#pragma mark- Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField     //Hide the keypad when we pressed return
{
    CGPoint offset;
    offset=CGPointMake(0, 0);
    [self.ScrollProfile setContentOffset:offset animated:YES];
    /*if (textField==txtName)
    {
        [self.txtLastName becomeFirstResponder];
    }
    if (textField==txtLastName)
    {
        [self.txtEmail becomeFirstResponder];
    }
    if (textField==txtEmail)
    {
        [self.txtNumber becomeFirstResponder];
    }
    if (textField==txtNumber)
    {
        [self.txtAddress becomeFirstResponder];
    }
    if (textField==txtAddress)
    {
        [self.txtBio  becomeFirstResponder];
    }
    if (textField==txtBio)
    {
        [self.txtZip becomeFirstResponder];
    }*/
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint offset;
    if(textField==self.txtEmail)
    {
        offset=CGPointMake(0, 0);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }

    if(textField==self.txtNumber)
    {
        offset=CGPointMake(0, 40);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }
    if(textField==self.txtAddress)
    {
        offset=CGPointMake(0, 80);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }
    if(textField==self.txtBio)
    {
        offset=CGPointMake(0, 120);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }
    if(textField==self.txtZip)
    {
        offset=CGPointMake(0, 160);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }
    if(textField==self.txtPassword)
    {
        offset=CGPointMake(0, 240);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }
    if(textField==self.txtNewPassword)
    {
        offset=CGPointMake(0, 280);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }
    if(textField==self.txtReNewPassword)
    {
        offset=CGPointMake(0, 320);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }


    /*
    if(textField == self.txtPassword)
    {
        UITextPosition *beginning = [self.txtPassword beginningOfDocument];
        [self.txtPassword setSelectedTextRange:[self.txtPassword textRangeFromPosition:beginning
                                                                            toPosition:beginning]];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -35, 320, 480);
            
        } completion:^(BOOL finished) { }];
    }
    if(textField == self.txtAddress)
    {
        UITextPosition *beginning = [self.txtAddress beginningOfDocument];
        [self.txtAddress setSelectedTextRange:[self.txtAddress textRangeFromPosition:beginning
                                                                          toPosition:beginning]];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -75, 320, 480);
            
        } completion:^(BOOL finished) { }];
    }
    if(textField == self.txtBio)
    {
        UITextPosition *beginning = [self.txtBio beginningOfDocument];
        [self.txtBio setSelectedTextRange:[self.txtBio textRangeFromPosition:beginning
                                                                  toPosition:beginning]];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -115, 320, 480);
            
        } completion:^(BOOL finished) { }];
    }
    else if(textField == self.txtZip)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -128, 320, 480);
            
        } completion:^(BOOL finished) { }];
    }
     */
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIDevice *thisDevice=[UIDevice currentDevice];
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 568)
        {
            if(textField == self.txtPassword)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 568);
                    
                } completion:^(BOOL finished) { }];
            }
            else if(textField == self.txtAddress)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 568);
                    
                } completion:^(BOOL finished) { }];
            }
            else if(textField == self.txtBio)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 568);
                    
                } completion:^(BOOL finished) { }];
            }
            else if (textField == self.txtZip)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 568);
                    
                } completion:^(BOOL finished) { }];
            }
            
        }
        else
        {
            
            if(textField == self.txtPassword)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 480);
                    
                } completion:^(BOOL finished) { }];
            }
            else if(textField == self.txtAddress)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 480);
                    
                } completion:^(BOOL finished) { }];
            }
            else if(textField == self.txtBio)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 480);
                    
                } completion:^(BOOL finished) { }];
            }
            else if (textField == self.txtZip)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 480);
                    
                } completion:^(BOOL finished) { }];
            }
            
        }
    }
}
@end
