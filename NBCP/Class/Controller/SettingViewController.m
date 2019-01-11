//
//  SettingViewController.m
//  NBCP
//
//  Created by Michael on 2019/1/11.
//  Copyright © 2019 Michael. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation SettingViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        
        NSArray *section0Title = @[
                                   @"账号与安全",
                                   ];
        NSArray *section0RightTitle = @[
                                        @"w18734340322",
                                        ];
        NSMutableArray *section0 = @[].mutableCopy;
        for (int i = 0; i < section0Title.count; i ++) {
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"title"] = section0Title[i];
            dic[@"rightTitle"]  = section0RightTitle[i];
            [section0 addObject:dic];
        }
        
        NSArray *section1Title = @[
                              @"自动登录",
                              @"手势密码",
                              ];
        NSArray *section1Key = @[
                                 AutoLogin,
                                 GesturesPassword,
                                 ];
        NSMutableArray *section1 = @[].mutableCopy;
        for (int i = 0; i < section1Title.count; i ++) {
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"title"] = section1Title[i];
            dic[@"key"]  = section1Key[i];
            [section1 addObject:dic];
        }
        
        NSArray *section2Title = @[
                                   @"关于某某",
                                   @"检查更新",
                                   @"新手指引",
                                   ];
        NSArray *section2RightTitle = @[
                                        @"",
                                        @"已是最新版本",
                                        @"",
                                        ];
        NSMutableArray *section2 = @[].mutableCopy;
        for (int i = 0; i < section2Title.count; i ++) {
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"title"] = section2Title[i];
            dic[@"rightTitle"] = section2RightTitle[i];
            [section2 addObject:dic];
        }
        [_dataSource addObject:section0];
        [_dataSource addObject:section1];
        [_dataSource addObject:section2];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self setUI];
}

-(void)setUpNavigation
{
    self.navigationItem.title = @"设置";
    [self setNavigationBarTitle:PFFontL(16) titleColor:HexColor(#000000)];
    UILabel *balance = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 16)];
    balance.textColor = HexColor(#4592F7);
    balance.font = PFFontL(16);
    balance.text = @"¥ 0.00";
    [balance sizeToFit];
    balance.frame = CGRectMake(0, 0, balance.frame.size.width, 16);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:balance];
}

-(void)setUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = HexColor(#F5F5F5);
    
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = HexColor(#F2F2F2);
    
    UIButton *logout = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 43)];
    logout.backgroundColor = WhiteColor;
    [logout setNormalTitle:@"退出当前账户"];
    [logout setNormalTitleColor:HexColor(#E95A6D)];
    [logout setBtnFont:PFFontL(15)];
    
    _tableView.tableFooterView = logout;
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataSource[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSArray *arr = self.dataSource[indexPath.section];
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Section0Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Section0Cell"];
            cell.textLabel.font = PFFontL(16);
            cell.textLabel.textColor = HexColor(#181818);
            cell.accessoryType = 0;
            
            cell.detailTextLabel.textColor = HexColor(#7F8080);
            cell.detailTextLabel.font = PFFontL(15);
        }
        
        NSDictionary *dic = arr[indexPath.row];
        cell.textLabel.text = dic[@"title"];
        cell.detailTextLabel.text = dic[@"rightTitle"];
        
    }else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Section1Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Section1Cell"];
            cell.textLabel.font = PFFontL(16);
            cell.textLabel.textColor = HexColor(#181818);
        }
        NSDictionary *dic = arr[indexPath.row];
        cell.textLabel.text = dic[@"title"];
        //添加一个开关按钮
        UISwitch *switchBtn = [UISwitch new];
        NSString *key = dic[@"key"];
        switchBtn.on = UserGetBool(key);
        [[switchBtn rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"x:%@",x);
            if (UserGetBool(key)==YES) {
                UserSetBool(NO, key);
            }else{
                UserSetBool(YES, key);
            }
        }];
        
        switchBtn.onTintColor = HexColor(#77B0ED);
        cell.accessoryView = switchBtn;
        
    }else if (indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Section2Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Section2Cell"];
            cell.textLabel.font = PFFontL(16);
            cell.textLabel.textColor = HexColor(#181818);
            cell.accessoryType = 1;
            
            cell.detailTextLabel.textColor = HexColor(#B7B7B7);
            cell.detailTextLabel.font = PFFontL(16);
        }
        NSDictionary *dic = arr[indexPath.row];
        cell.textLabel.text = dic[@"title"];
        cell.detailTextLabel.text = dic[@"rightTitle"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 32;
    }
    if (section == 1) {
        return 14;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 88;
    }
    if (section == 1) {
        return 12;
    }
    if (section == 2) {
        return 12;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 0) {
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, 88)];
        footView.backgroundColor = WhiteColor;
        NSArray *title = @[
                           @"存款",
                           @"提款",
                           @"转账",
                           @"修改限额",
                           ];
        NSArray *image = @[
                           @"setting_deposit",
                           @"setting_withdrawals",
                           @"setting_transfer",
                           @"setting_modifyTheLimit",
                           ];
        
        CGFloat avgW = footView.width/4;
        for (int i = 0; i < 4; i ++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * avgW, 0, avgW, 88)];
            btn.tag = 10086 + i;
            [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:btn];
            [btn setNormalTitleColor:HexColor(#181818)];
            [btn setBtnFont:PFFontL(16)];
            [btn setNormalTitle:title[i]];
            [btn setNormalImage:UIImageNamed(image[i])];
            [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:17];
            [btn addBorderTo:BorderTypeLeft borderColor:HexColor(#F2F2F2)];
        }
    }
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)selectAction:(UIButton *)sender
{
    NSInteger tag = sender.tag - 10086;
    switch (tag) {
        case 0:
            NSLog(@"点击了存款");
            break;
        case 1:
            NSLog(@"点击了提款");
            break;
        case 2:
            NSLog(@"点击了转账");
            break;
        case 3:
            NSLog(@"点击了修改限额");
            break;
            
        default:
            break;
    }
}

@end
