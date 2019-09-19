//
//  QuestionTableViewCell.h
//  stackoverflow
//
//  Created by Ivan on 19/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *user_pic_imv;
@property (weak, nonatomic) IBOutlet UILabel *user_name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *question_title_lbl;
@property (weak, nonatomic) IBOutlet UICollectionView *tags_collection_view;


@end

NS_ASSUME_NONNULL_END
