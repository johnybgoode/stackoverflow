//
//  ViewController.h
//  stackoverflow
//
//  Created by Ivan on 16/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;



@end

