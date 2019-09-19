//
//  TagCollectionViewCell.h
//  stackoverflow
//
//  Created by Ivan on 19/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagCollectionViewCell : UICollectionViewCell
@property(weak, nonatomic) IBOutlet UILabel *tag_title_label;
@end

NS_ASSUME_NONNULL_END
