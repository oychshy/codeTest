//
//  TaskCell.h
//  MultitaskSuspendDownload
//
//  Created by yanglin on 2018/5/29.
//  Copyright © 2018年 Softisland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicFileModel.h"

@interface TaskCell : UITableViewCell
-(void)SetCellWithModel:(ComicFileModel*)model;
@end
