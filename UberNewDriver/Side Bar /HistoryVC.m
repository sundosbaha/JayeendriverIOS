//
//  HistoryVC.m
//  UberforX Provider
//
//  Created by My Mac on 11/15/14.
//  Copyright (c) 2014 Deep Gami. All rights reserved.
//

#import "HistoryVC.h"
#import "HistoryCell.h"
#import "UIImageView+Download.h"
#import "UtilityClass.h"
#import "PickMeUpMapVC.h"
#import "ArrivedMapVC.h"
#import "FeedBackVC.h"

@interface HistoryVC ()
{
    NSMutableArray *arrHistory;
    NSMutableString *strUserId;
    NSMutableString *strUserToken;
    NSMutableArray *arrForDate;
    NSMutableArray *arrForSection;
    NSUserDefaults *prefl;
    CGFloat screenWidth,screenHeight;CGRect screenRect;

    BOOL internet;
}

@end

@implementation HistoryVC

@synthesize tableHistory;


#pragma mark-
#pragma mark- View Delegate Method

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefl = [[NSUserDefaults alloc]init];
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    NSLog(@"Screen Width %f",screenWidth);
    NSLog(@"Screen Height %f",screenHeight);
    [super setBackBarItem];
    arrHistory=[[NSMutableArray alloc]init];
    [self customFont];
    [self localizeString];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    internet=[APPDELEGATE connected];
    [self.paymentView setHidden:YES];
    
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    [pref synchronize];
    strUserId=[pref objectForKey:PREF_USER_ID];
    strUserToken=[pref objectForKey:PREF_USER_TOKEN];
    [APPDELEGATE showLoadingWithTitle:NSLocalizedStringFromTable(@"LOADING_HISTORY",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    [self getHistory];
    self.imgNoItems.hidden=YES;
    self.navigationController.navigationBarHidden=NO;
    [self.btnMenu setTitle:NSLocalizedStringFromTable(@"History",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.btnMenu setTitle:NSLocalizedStringFromTable(@"History",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
}

#pragma mark-
#pragma mark- customFont

-(void)customFont
{
//    self.lblBasePrice.font=[UberStyleGuide fontRegular];
//    self.lblDistCost.font=[UberStyleGuide fontRegular];
//    self.lblPerDist.font=[UberStyleGuide fontRegular];
//    self.lblPerTime.font=[UberStyleGuide fontRegular];
//    self.lblTimeCost.font=[UberStyleGuide fontRegular];
    //self.lblTotal.font=[UberStyleGuide fontRegular:30.0f];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    if ([[pref objectForKey:@"ArabicLanguage"] isEqualToString:@"YesArabic"])
    {
        
        if (screenHeight == 568.000000)
        {
            NSLog(@"Standard Resolution Device");
            [_lblBase_Price setFrame:CGRectMake(220, 158, 175, 35)];
            [_lblBasePrice setFrame:CGRectMake(-10, 158, 96, 35)];
            [_lblDist_Cost setFrame:CGRectMake(220, 190, 175, 35)];
            [_lblDistCost setFrame:CGRectMake(-10, 200, 96, 35)];
            [_lblPerDist setFrame:CGRectMake(220, 210, 175, 35)];
            [_lblTime_Cost setFrame:CGRectMake(220, 230, 175, 35)];
            [_lblTimeCost setFrame:CGRectMake(-10, 242, 96, 35)];
            [_lblPerTime setFrame:CGRectMake(220, 252, 175, 35)];
            [_lbl_Referrel setFrame:CGRectMake(220, 315, 175, 35)];
            [_lblReferrel setFrame:CGRectMake(-10, 315, 96, 35)];
            [_lbl_Promo setFrame:CGRectMake(220, 280, 175, 35)];
            [_lblPromo setFrame:CGRectMake(-10, 284, 96, 35)];
            [_LblAdminCommission setFrame:CGRectMake(220, 332, 175, 35)];
            [_LblAdminCommissionValue setFrame:CGRectMake(-10, 332, 96, 35)];
            
        }
        if (screenHeight == 667.000000)
        {
            NSLog(@"High Resolution Device");
            [_lblBase_Price setFrame:CGRectMake(270, 178, 175, 35)];
            [_lblBasePrice setFrame:CGRectMake(-10, 178, 96, 35)];
            [_lblDist_Cost setFrame:CGRectMake(270, 212, 175, 35)];
            [_lblDistCost setFrame:CGRectMake(-10, 224, 96, 35)];
            [_lblPerDist setFrame:CGRectMake(270, 238, 175, 35)];
            [_lblTime_Cost setFrame:CGRectMake(270, 270, 175, 35)];
            [_lblTimeCost setFrame:CGRectMake(-10, 282, 96, 35)];
            [_lblPerTime setFrame:CGRectMake(270, 292, 175, 35)];
            [_lbl_Referrel setFrame:CGRectMake(270, 330, 175, 35)];
            [_lblReferrel setFrame:CGRectMake(-10, 330, 96, 35)];
            [_lbl_Promo setFrame:CGRectMake(270, 370, 175, 35)];
            [_lblPromo setFrame:CGRectMake(-10, 374, 96, 35)];
            [_LblAdminCommission setFrame:CGRectMake(270, 412, 175, 35)];
            [_LblAdminCommissionValue setFrame:CGRectMake(-10, 412, 96, 35)];
            
        }
        if (screenHeight == 736.000000)
        {
            NSLog(@"iPhone 7 & 7plus");
            [_lblBase_Price setFrame:CGRectMake(300, 208, 175, 35)];
            [_lblBasePrice setFrame:CGRectMake(-10, 208, 96, 35)];
            [_lblDist_Cost setFrame:CGRectMake(300, 242, 175, 35)];
            [_lblDistCost setFrame:CGRectMake(-10, 254, 96, 35)];
            [_lblPerDist setFrame:CGRectMake(300, 268, 175, 35)];
            [_lblTime_Cost setFrame:CGRectMake(300, 300, 175, 35)];
            [_lblTimeCost setFrame:CGRectMake(-10, 312, 96, 35)];
            [_lblPerTime setFrame:CGRectMake(300, 322, 175, 35)];
            [_lbl_Referrel setFrame:CGRectMake(300, 370, 175, 35)];
            [_lblReferrel setFrame:CGRectMake(-10, 370, 96, 35)];
            [_lbl_Promo setFrame:CGRectMake(300, 410, 175, 35)];
            [_lblPromo setFrame:CGRectMake(-10, 414, 96, 35)];
            [_LblAdminCommission setFrame:CGRectMake(300, 450, 175, 35)];
            [_LblAdminCommissionValue setFrame:CGRectMake(-10, 454, 96, 35)];
        }

    }
    
    self.btnMenu.titleLabel.font=[UberStyleGuide fontRegular];
    self.btnClose=[APPDELEGATE setBoldFontDiscriptor:self.btnClose];
    
    self.btnMenu.titleLabel.textColor = [UberStyleGuide colorDefault];
    
    self.lblBase_Price.textColor = [UberStyleGuide colorDefault];
    self.lblBasePrice.textColor = [UberStyleGuide colorDefault];
    self.lblDist_Cost.textColor = [UberStyleGuide colorDefault];
    self.lblDistCost.textColor = [UberStyleGuide colorDefault];
    self.lblPerDist.textColor = [UberStyleGuide colorDefault];
    self.lblTime_Cost.textColor = [UberStyleGuide colorDefault];
    self.lblTimeCost.textColor = [UberStyleGuide colorDefault];
    self.lblPerTime.textColor = [UberStyleGuide colorDefault];
    self.lbl_Referrel.textColor = [UberStyleGuide colorDefault];
    self.lblReferrel.textColor = [UberStyleGuide colorDefault];
    self.lbl_Promo.textColor = [UberStyleGuide colorDefault];
    self.lblPromo.textColor = [UberStyleGuide colorDefault];
    self.LblAdminCommission.textColor = [UberStyleGuide colorDefault];
    self.LblAdminCommissionValue.textColor = [UberStyleGuide colorDefault];
   
}

-(void)localizeString
{
    
    self.lblInvoice.text = NSLocalizedStringFromTable(@"Invoice",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.lblTime_Cost.text = NSLocalizedStringFromTable(@"TIME COST",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lblDist_Cost.text = NSLocalizedStringFromTable(@"DISTANCE COST",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lblTotalDue.text = NSLocalizedStringFromTable(@"Total Due",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lblBase_Price.text = NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lbl_Promo.text = NSLocalizedStringFromTable(@"PROMO BONUS",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lbl_Referrel.text = NSLocalizedStringFromTable(@"REFERRAL BONUS",[prefl objectForKey:@"TranslationDocumentName"], nil);
    
    self.LblAdminCommission.text=NSLocalizedStringFromTable(@"Waiting_Cost",[prefl objectForKey:@"TranslationDocumentName"],nil);
    
    [self.btnClose setTitle:NSLocalizedStringFromTable(@"CLOSE",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnClose setTitle:NSLocalizedStringFromTable(@"CLOSE",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
    
}

#pragma mark-
#pragma mark- Get History API Method



-(void)getHistory
{
    if(internet)
    {
        NSMutableString *pageUrl=[NSMutableString stringWithFormat:@"%@?%@=%@&%@=%@",FILE_HISTORY,PARAM_ID,strUserId,PARAM_TOKEN,strUserToken];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:pageUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             
             NSLog(@"History Data= %@",response);
             
             [APPDELEGATE hideLoadingView];
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     arrHistory=[response valueForKey:@"requests"];
                     if (arrHistory.count==0)
                     {
                         self.imgNoItems.hidden=NO;
                         self.tableHistory.hidden=YES;
                     }
                     else
                     {
                         [self makeSection];
                         self.imgNoItems.hidden=YES;
                         self.tableHistory.hidden=NO;
                         [tableHistory reloadData];
                     }
                 }
             }
             
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
#pragma mark- Table View Delegate

-(void)makeSection
{
    arrForDate=[[NSMutableArray alloc]init];
    arrForSection=[[NSMutableArray alloc]init];
    NSMutableArray *arrtemp=[[NSMutableArray alloc]init];
    [arrtemp addObjectsFromArray:arrHistory];
    NSSortDescriptor *distanceSortDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO
                                                                              selector:@selector(localizedStandardCompare:)];
    
    [arrtemp sortUsingDescriptors:@[distanceSortDiscriptor]];
    
    for (int i=0; i<arrtemp.count; i++)
    {
        NSMutableDictionary *dictDate=[[NSMutableDictionary alloc]init];
        dictDate=[arrtemp objectAtIndex:i];
        
        NSString *temp=[dictDate valueForKey:@"date"];
        NSArray *arrDate=[temp componentsSeparatedByString:@" "];
        NSString *strdate=[arrDate objectAtIndex:0];
        if(![arrForDate containsObject:strdate])
        {
            [arrForDate addObject:strdate];
        }
        
    }
    
    for (int j=0; j<arrForDate.count; j++)
    {
        NSMutableArray *a=[[NSMutableArray alloc]init];
        [arrForSection addObject:a];
    }
    for (int j=0; j<arrForDate.count; j++)
    {
        NSString *strTempDate=[arrForDate objectAtIndex:j];
        
        for (int i=0; i<arrtemp.count; i++)
        {
            NSMutableDictionary *dictSection=[[NSMutableDictionary alloc]init];
            dictSection=[arrtemp objectAtIndex:i];
            NSArray *arrDate=[[dictSection valueForKey:@"date"] componentsSeparatedByString:@" "];
            NSString *strdate=[arrDate objectAtIndex:0];
            if ([strdate isEqualToString:strTempDate])
            {
                [[arrForSection objectAtIndex:j] addObject:dictSection];
                
            }
        }
        
    }
    
    
}


    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[arrForSection objectAtIndex:section] count];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrForSection.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
    UILabel *lblDate=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 20)];
    lblDate.font=[UberStyleGuide fontRegular];
    lblDate.textColor=[UberStyleGuide colorDefault];
    NSString *strDate=[arrForDate objectAtIndex:section];
    NSString *current=[[UtilityClass sharedObject] DateToString:[NSDate date] withFormate:@"yyyy-MM-dd"];
    
    
    ///   YesterDay Date Calulation

// changed by natarajan

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -1;
    NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                   toDate:[NSDate date]
                                                  options:0];
    NSString *strYesterday=[[UtilityClass sharedObject] DateToString:yesterday withFormate:@"yyyy-MM-dd"];
    
    
    if([strDate isEqualToString:current])
    {
        lblDate.text=NSLocalizedStringFromTable(@"Today",[prefl objectForKey:@"TranslationDocumentName"],nil);
        headerView.backgroundColor=[UberStyleGuide colorDefault];
        lblDate.textColor=[UIColor whiteColor];
         lblDate.font=[UberStyleGuide fontRegular];
    }
    else if ([strDate isEqualToString:strYesterday])
    {
        lblDate.text=NSLocalizedStringFromTable(@"Yesterday",[prefl objectForKey:@"TranslationDocumentName"],nil);
         lblDate.font=[UberStyleGuide fontRegular];
    }
    else
    {
        NSDate *date=[[UtilityClass sharedObject]stringToDate:strDate withFormate:@"yyyy-MM-dd"];
        NSString *text=[[UtilityClass sharedObject]DateToString:date withFormate:@"dd MMMM yyyy"];//2nd Jan 2015
        lblDate.text=text;
         lblDate.font=[UberStyleGuide fontRegular];
    }
    
    [headerView addSubview:lblDate];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSMutableDictionary *pastDict=[[arrForSection objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        NSMutableDictionary *dictOwner=[pastDict valueForKey:@"owner"];
    
        static NSString *CellIdentifier = @"Cell";
    
        HistoryCell *cell = [tableHistory dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell==nil)
        {
            cell=[[HistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    cell.lblName.font=[UberStyleGuide fontRegularBold:12.0f];
    cell.lblCost.font=[UberStyleGuide fontRegular:20.0f];
    cell.lblType.font=[UberStyleGuide fontRegular];
    
    
    NSDate *dateTemp=[[UtilityClass sharedObject]stringToDate:[pastDict valueForKey:@"date"]];
    NSString *strDate=[[UtilityClass sharedObject]DateToString:dateTemp withFormate:@"hh:mm a"];
    cell.lblDateTime.text=[NSString stringWithFormat:@"%@",strDate];
    //cell.lblDateTime.font=[UberStyleGuide fontRegular];
    cell.lblName.text=[NSString stringWithFormat:@"%@ %@",[dictOwner valueForKey:@"first_name"],[dictOwner valueForKey:@"last_name"]];
    cell.lblType.text=[NSString stringWithFormat:@"%@",[dictOwner valueForKey:@"phone"]];
    cell.lblCost.text=[NSString stringWithFormat:@"JOD%.2f",[[pastDict valueForKey:@"total"] floatValue]];
    
    [cell.imgOwner downloadFromURL:[dictOwner valueForKey:@"picture"] withPlaceholder:nil];
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationController.navigationBarHidden=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableDictionary *pastDict=[[arrForSection objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    self.LblAdminCommissionValue.text=[NSString stringWithFormat:@"JOD %.2f",[[pastDict valueForKey:@"waiting_price"] floatValue]];
    self.LblDriverCommissionValue.text=[NSString stringWithFormat:@"JOD %.2f",[[pastDict valueForKey:@"driver_per_payment"] floatValue]];
   
    self.lblBasePrice.text=[NSString stringWithFormat:@"JOD %.2f",[[pastDict valueForKey:@"base_price"] floatValue]];
    self.lblDistCost.text=[NSString stringWithFormat:@"JOD %.2f",[[pastDict valueForKey:@"distance_cost"] floatValue]];
    self.lblTimeCost.text=[NSString stringWithFormat:@"JOD %.2f",[[pastDict valueForKey:@"time_cost"] floatValue]];
    self.lblTotal.text=[NSString stringWithFormat:@"JOD %.2f",[[pastDict valueForKey:@"total"] floatValue]];
    self.lblPromo.text=[NSString stringWithFormat:@"JOD %.2f",[[pastDict valueForKey:@"promo_bonus"] floatValue]];
    self.lblReferrel.text=[NSString stringWithFormat:@"JOD %.2f",[[pastDict valueForKey:@"referral_bonus"] floatValue]];
    
    
    float totalDist=[[pastDict valueForKey:@"distance_cost"] floatValue];
    float Dist=[[pastDict valueForKey:@"distance"]floatValue];
    float NetDistance = Dist - 1.0;
    NSLog(@"Net Distance=%f",NetDistance);
    NSLog(@"Distance Price=%f",[[pastDict valueForKey:@"distance_price"] floatValue]);
    NSLog(@"Set Base Distance=%f",[[pastDict valueForKey:@"setbase_distance"] floatValue]);
    NSLog(@"Price Per Unit Time=%f",[[pastDict valueForKey:@"price_per_unit_time"] floatValue]);
    NSString *Distance_Price = [pastDict valueForKey:@"distance_price"];
    NSString *SetBaseDistance = [pastDict valueForKey:@"setbase_distance"];
    NSString *PricePerUnitTime = [pastDict valueForKey:@"price_per_unit_time"];
    
    
    if ([[pastDict valueForKey:@"unit"]isEqualToString:NSLocalizedStringFromTable(@"kms",[prefl objectForKey:@"TranslationDocumentName"],nil)])
    {
        totalDist=totalDist*0.621317;
        Dist=Dist*0.621371;
    }
    if(Dist!=0)
    {
         //        self.lblPerDist.text=[NSString stringWithFormat:@"%.2fJOD %@",(totalDist/Dist),NSLocalizedStringFromTable(@"per mile",[prefl   objectForKey:@"TranslationDocumentName"],nil)];
        if (Dist<[SetBaseDistance doubleValue])
        {
            self.lblBase_Price.text=[NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil)];
            
            self.lblDist_Cost.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"DISTANCE COST", nil)];
            
            self.lblPerDist.text=[NSString stringWithFormat:@"%.2fJOD %@",[Distance_Price floatValue],NSLocalizedStringFromTable(@"per mile",[prefl objectForKey:@"TranslationDocumentName"],nil)];
            NSLog(@" IF Calling Label Value1 =%@",self.lblPerDist.text);
        }
        else
        {
            self.lblBase_Price.text=[NSString stringWithFormat:@"%@ (%.2f KM)",NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil),[SetBaseDistance floatValue]];
            
            self.lblDist_Cost.text = [NSString stringWithFormat:@"%@ (%.2f KM)",NSLocalizedString(@"DISTANCE COST", nil),NetDistance];
            
            self.lblPerDist.text=[NSString stringWithFormat:@"%.2fJOD %@",[Distance_Price floatValue],NSLocalizedStringFromTable(@"per mile",[prefl objectForKey:@"TranslationDocumentName"],nil)];
            NSLog(@"Else Calling Label Value2 =%@",self.lblPerDist.text);
        }

    }
    else
    {
        self.lblBase_Price.text=NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil);
        self.lblPerDist.text=[NSString stringWithFormat:@"0JOD %@",NSLocalizedStringFromTable(@"per mile",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    }
    
    //float totalTime=[[pastDict valueForKey:@"time_cost"] floatValue];
    float Time=[[pastDict valueForKey:@"time"]floatValue];
    if(Time!=0)
    {
        self.lblPerTime.text=[NSString stringWithFormat:@"%.2fJOD %@",[PricePerUnitTime floatValue],NSLocalizedStringFromTable(@"per mins",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    }
    else
    {
        self.lblPerTime.text=[NSString stringWithFormat:@"0JOD %@",NSLocalizedStringFromTable(@"per mins",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    }
        
    

    [self.paymentView setHidden:NO];

}



#pragma mark-
#pragma mark- Button Method


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
- (IBAction)closeBtnPressed:(id)sender
{
    self.navigationController.navigationBarHidden=NO;
    [self.paymentView setHidden:YES];
}
@end
