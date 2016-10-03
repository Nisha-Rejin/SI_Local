//
//  SIBaseCollectionViewCell.m
//  Selling Intelligence
//
//  Created by Sailesh on 28/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIBaseCollectionViewCell.h"

@implementation SIBaseCollectionViewCell
@synthesize tableViewAlerts,arrayMenuAlerts,alertsLoaderDelegate,arrayImages;



- (void)drawRect:(CGRect)rect{
    
    arrayMenuAlerts=[NSMutableArray arrayWithObjects:@"SKU Voids",@"Missing Sku's (POG)",@"Innovation Opportunity",@"PurePlay Opportunity",nil];
    arrayImages=[NSMutableArray arrayWithObjects:@"SKU-Voids",@"SKU`s-missing",@"innovation-opportunity",@"pure-play", nil];

    
    tableViewAlerts.dataSource = self;
    tableViewAlerts.delegate = self;
    [tableViewAlerts reloadData];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    tableViewAlerts.dataSource=self;
    tableViewAlerts.delegate=self;
    self.tableViewAlerts.frame = self.contentView.bounds;
}




#pragma mark-tableview Datasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [arrayMenuAlerts count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SIBaseTableViewCell *cell = ( SIBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.lblAlertsTitle.text = arrayMenuAlerts[indexPath.row];
    NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"/SellingIntelligence.bundle"];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];

    [cell.imgViewIcon setImage:[UIImage imageNamed:arrayImages[indexPath.row] inBundle:frameworkBundle compatibleWithTraitCollection:nil]];

    [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background3.png" inBundle:frameworkBundle compatibleWithTraitCollection:nil]]];
    [self.tableViewAlerts addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    
    
    return cell;
}



#pragma mark-tableview delegate

//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    // Remove seperator inset
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    // Prevent the cell from inheriting the Table View's margin settings
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//    
//    // Explictly set your cell's layout margins
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row==0) {
        [[self alertsLoaderDelegate] loadAlertsFor:SKUVOIDS];
    }
    else if (indexPath.row==1)
    {
        [[self alertsLoaderDelegate] loadAlertsFor:MISSINGSKUSINPOG];
    }
    else if (indexPath.row==2)
    {
        [[self alertsLoaderDelegate] loadAlertsFor:INNOVATION];
    }
    else
    {
        [[self alertsLoaderDelegate] loadAlertsFor:PUREPLAY];
    }

}


@end
