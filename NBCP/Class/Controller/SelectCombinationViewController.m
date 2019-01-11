//
//  SelectCombinationViewController.m
//  NBCP
//
//  Created by Michael on 2019/1/11.
//  Copyright © 2019 Michael. All rights reserved.
//

#import "SelectCombinationViewController.h"

#import "SelectCombinationCell.h"

@interface SelectCombinationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UILabel *balance;

@end

@implementation SelectCombinationViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *icon = @[
                          @"entertainmentIcon",
                          @"normalIcon",
                          @"seniorIcon",
                          @"VIPIcon",
                          ];
        NSArray *title = @[
                           @"娱乐",
                           @"普通",
                           @"高级",
                           @"贵宾",
                           ];
        NSArray *minu = @[
                          @"5",
                          @"1,000",
                          @"3,000",
                          @"10,000",
                          ];
        NSArray *high = @[
                          @"3,000",
                          @"20,000",
                          @"30,000",
                          @"50,000",
                          ];
        for (int i = 0; i < icon.count; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            dic[@"icon"] = icon[i];
            dic[@"title"] = title[i];
            dic[@"low"] = minu[i];
            dic[@"high"] = high[i];
            [_dataSource addObject:dic];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self setUI];
    
    [self setUpHeadView];
}

-(void)setUpNavigation
{
    self.navigationItem.title = @"选择组合";
    [self setNavigationBarTitle:PFFontL(17) titleColor:WhiteColor];
    [self setNavigationBarBackgroundColor:HexColor(#4592F7)];
}

-(void)setUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WhiteColor;
    
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = HexColor(#D0E6FE);
//    _tableView.separatorColor = ClearColor;
    [_tableView registerClass:[SelectCombinationCell class] forCellReuseIdentifier:SelectCombinationCellID];
}

-(void)setUpHeadView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 156)];
        _headView.backgroundColor = HexColor(#F9FBFE);
        
        UILabel *topLabel = [UILabel new];
        _balance = [UILabel new];
        UILabel *transfer = [UILabel new];
        UILabel *noticeLabel = [UILabel new];
        
        [_headView sd_addSubviews:@[
                                    topLabel,
                                    _balance,
                                    noticeLabel,
                                    transfer,
                                    ]];
        topLabel.sd_layout
        .centerXEqualToView(_headView)
        .topSpaceToView(_headView, 27)
        .heightIs(16)
        ;
        [topLabel setSingleLineAutoResizeWithMaxWidth:100];
        topLabel.textColor = HexColor(#B8BDC2);
        topLabel.font = PFFontL(15);
        topLabel.text = @"快乐彩钱包";
        
        _balance.sd_layout
        .centerXEqualToView(_headView)
        .topSpaceToView(topLabel, 14)
        .heightIs(20)
        ;
        [_balance setSingleLineAutoResizeWithMaxWidth:200];
        _balance.textColor = HexColor(#4592F7);
        _balance.font = PFFontL(24);
        
        noticeLabel.sd_layout
        .leftEqualToView(_headView)
        .rightEqualToView(_headView)
        .bottomSpaceToView(_headView, 20)
        .heightIs(14)
        ;
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        noticeLabel.textColor = HexColor(#B8BDC2);
        noticeLabel.font = PFFontL(13);
        noticeLabel.text = @"在 [设置] 中可以再次 [转账] 或 [修改限额]";
        [noticeLabel updateLayout];
        
        transfer.sd_layout
        .centerXEqualToView(_headView)
        .bottomSpaceToView(noticeLabel, 15)
        .heightIs(18)
        ;
        [transfer setSingleLineAutoResizeWithMaxWidth:100];
        transfer.textColor = HexColor(#B8BDC2);
        transfer.font = PFFontL(16);
        transfer.text = @"转账";
        [transfer updateLayout];
        [transfer addBorderTo:BorderTypeBottom borderColor:HexColor(#B8BDC2)];
    }
    _balance.text = @"¥ 36.00";
    self.tableView.tableHeaderView = _headView;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCombinationCell *cell = (SelectCombinationCell *)[tableView dequeueReusableCellWithIdentifier:SelectCombinationCellID];
    NSDictionary *model = self.dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![YXHeader checkLogin]) {
        return;
    }
    
}



@end
