//
//  SelectCombinationCell.h
//  NBCP
//
//  Created by Michael on 2019/1/11.
//  Copyright © 2019 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const SelectCombinationCellID;

@interface SelectCombinationCell : UITableViewCell

@property (nonatomic ,strong) NSDictionary *model;

@end

NS_ASSUME_NONNULL_END
