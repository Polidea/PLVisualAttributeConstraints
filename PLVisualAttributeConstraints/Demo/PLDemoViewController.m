//
//  Created by Kamil Jaworski on 16.07.2013.
//  kamil.jaworski@gmail.com
//


#import "PLDemoViewController.h"
#import "PLDemoView.h"

@implementation PLDemoViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView {
    self.view = [[PLDemoView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
//    self.view.backgroundColor = [UIColor greenColor];
}

@end
