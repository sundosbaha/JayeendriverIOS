//
//  WalletVC.m
//  AloBasha  Driver
//
//  Created by Spextrum on 08/06/17.
//  Copyright © 2017 Deep Gami. All rights reserved.
//
#import "AFNetworking.h"
#import "WalletVC.h"

@interface WalletVC ()
{
    
}

@end

@implementation WalletVC
{
    NSUserDefaults *pref;
    NSString *NetAmountAvailable,*AmountToWithdraw;
    NSDictionary *Avalilable_AmountDict;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.ViewForWithdrawAmount setHidden:YES];
    self.ViewForWithdrawAmount.layer.cornerRadius = 5.0;
    self.BtnConfirm.layer.cornerRadius=5.0;
    self.BtnCancel.layer.cornerRadius=5.0;
    
    pref = [NSUserDefaults standardUserDefaults];
//    [self.navigationController.navigationBar s:YES];
//    [self.Bar_Navigation setHidden:NO];
    [self addBackButtonWithImageName:@"back"];
    [self GetAvailableAmount];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)BtnMoneyAdd:(id)sender
{
    [self.ViewForWithdrawAmount setHidden:NO];
}

- (IBAction)Back_Button:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)ConfirmButton:(id)sender
{
    AmountToWithdraw = self.TxtAmount.text;
    [self Validation_Method];
}

- (IBAction)CancelButton:(id)sender
{
    [self.ViewForWithdrawAmount setHidden:YES];
}


#pragma mark - Get Available Amount in Wallet

-(void)GetAvailableAmount
{
    NSString * strForUserId=[pref objectForKey:PREF_USER_ID];
    NSString * strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    
    [dictParam setObject:strForUserId forKey:@"walkerId"];
    [dictParam setObject:strForUserToken forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://notanotherfruit.com/wallet/public/provider/provider_balance" parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         [APPDELEGATE showLoadingWithTitle:@""];
         NSLog(@"Available Amount in Wallet: %@", responseObject);
         Avalilable_AmountDict = [responseObject valueForKey:@"wallet"];
         NetAmountAvailable = [NSString stringWithFormat:@"$ %.2f",[[[responseObject valueForKey:@"wallet"]valueForKey:@"total_balance"]floatValue]];
         [pref setObject:NetAmountAvailable forKey:@"AmountAvailable"];
         [pref synchronize];
         [self.LblAmount setText:NetAmountAvailable];
         [APPDELEGATE hideLoadingView];
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [[AppDelegate sharedAppDelegate]hideLoadingView];
         
     }];

}

#pragma mark - Withdraw Amount From Wallet

-(void)WithdrawAmountFromWallet
{
    NSString * strForUserId=[pref objectForKey:PREF_USER_ID];
    NSString * strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    
    [dictParam setObject:strForUserId forKey:@"walkerId"];
    [dictParam setObject:strForUserToken forKey:@"token"];
    [dictParam setObject:AmountToWithdraw forKey:@"amount"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://notanotherfruit.com/wallet/public/provider/provider_spend_amounts" parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         [APPDELEGATE showLoadingWithTitle:@""];
         NSLog(@"Withdrawn Amount From Wallet: %@", responseObject);
         if ([[responseObject valueForKey:@"success"] integerValue]==0)
         {
             [APPDELEGATE hideLoadingView];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert",[pref objectForKey:@"TranslationDocumentName"],nil)
                                                                           message:[responseObject valueForKey:@"error"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [pref objectForKey:@"TranslationDocumentName"],nil)
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                            }];
             [alert addAction:cancelButton];
             [self presentViewController:alert animated:YES completion:nil];
             return;
         }
         else if ([[responseObject valueForKey:@"success"] integerValue]==1)
         {
             [APPDELEGATE hideLoadingView];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert",[pref objectForKey:@"TranslationDocumentName"],nil)
                                                                           message:@"The Amount is Successfully Transfered to your Account"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [pref objectForKey:@"TranslationDocumentName"],nil)
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                            }];
             [alert addAction:cancelButton];
             [self presentViewController:alert animated:YES completion:nil];
             return;
         }
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [[AppDelegate sharedAppDelegate]hideLoadingView];
         
     }];

}

#pragma mark - Add Back button in Navigation Bar
/**
 *  @brief set left bar button with custom image (or custom view)
 */
- (void)addBackButtonWithImageName:(NSString *)imageName
{
    // init your custom button, or your custom view
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 22); // custom frame
    [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // set left barButtonItem with custom view
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backButtonPressed:(id)sender
{
    [pref setObject:@"YesWalletRight" forKey:@"WalletRight"];
    [pref synchronize];
    [self performSegueWithIdentifier:@"BackToHome" sender:self];
}


#pragma mark - Validate Textfield & Verify Amount Withdrawn

-(void)Validation_Method
{
    NSLog(@"net Amount = %@",Avalilable_AmountDict);
    NSLog(@"net Amount 1 = %.2f",[[Avalilable_AmountDict valueForKey:@"total_balance"] floatValue]);
    
    if (self.TxtAmount.text.length == 0)
    {

        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert",[pref objectForKey:@"TranslationDocumentName"],nil)
                                                                      message:NSLocalizedStringFromTable(@"Please Enter a Valid Amount to Withdraw",[pref objectForKey:@"TranslationDocumentName"],nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [pref objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else if ([AmountToWithdraw floatValue] == [[Avalilable_AmountDict valueForKey:@"total_balance"] floatValue])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert",[pref objectForKey:@"TranslationDocumentName"],nil)
                                                                      message:NSLocalizedStringFromTable(@"Please Enter a Valid Amount to Withdraw",[pref objectForKey:@"TranslationDocumentName"],nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [pref objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else if ([AmountToWithdraw floatValue] > [[Avalilable_AmountDict valueForKey:@"total_balance"]floatValue])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert",[pref objectForKey:@"TranslationDocumentName"],nil)
                                                                      message:NSLocalizedStringFromTable(@"Insufficient Balance",[pref objectForKey:@"TranslationDocumentName"],nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [pref objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else
    {
        [self WithdrawAmountFromWallet];
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.TxtAmount resignFirstResponder];
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
