//
//  Access.h
//  ms
//
//  Created by mac on 12-12-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQL.h"

@interface Access : NSObject

//..................................................................................电子书..................................................................................
//书
+(id)getBrandstoryWithCategory:(NSNumber*)value;

+(id)getBrandstoryPictureWithId:(NSNumber*)value;


//..................................................................................样板房..................................................................................
+(id)Goproduct:(int)proID;


+(id)getRoomPic;

+(id)getRoomPicByspaceType:(int)spaceType;
+(id)getRoomPicByspaceTypeAndLevSize:(int)spaceType lev:(id)lev size:(id)size spaceid:(int)spaceid;



+(id)getRoomPicByspaceTypeAndLev:(int)spaceType lev:(id)lev spaceid:(int)spaceid;


+(id)getRoomPicByspaceTypeAndSize:(int)spaceType size:(id)size spaceid:(int)spaceid;


//

+(id)getRoomdefaultWallCapPath:(int)roomID;
+(id)getRoomWallCapPath:(int)roomID wallID:(int)wallID capID:(int)capID;


+(id) getwallThumb:(uint)roomID;

+(id) getcapThumb:(uint)roomID;

//

+(id) getoneThumb:(uint)roomID;

//实景样板房小图
+(id)getSenceRoomSFThumb:(int)roomID;

+(id)getSenceRoomYZThumb:(int)roomID;
+(id)getSenceRoomCJThumb:(int)roomID;
+(id)getSenceRoomSGThumb:(int)roomID;
+(id)getSenceRoomDSGThumb:(int)roomID;

+(id)getSenceRoomSFColorThumbBypro:(int)roomID proID:(int)proID;


+(id)getSenceRoomYZColorThumbBypro:(int)roomID proID:(int)proID;


+(id)getSenceRoomCJColorThumbBypro:(int)roomID proID:(int)proID;

+(id)getSenceRoomSGColorThumbBypro:(int)roomID proID:(int)proID;


+(id)getSenceRoomDSGColorThumbBypro:(int)roomID proID:(int)proID;


+(id)getSenceDefaultPath:(int)roomID;

//chanpin
+(id)getSencePathBySIXID_sf:(int)roomID sfid:(int)sfid yzid:(int)yzid cjid:(int)cjid sgid:(int)sgid dsgid:(int)dsgid sfcolID:(int)sfcolID yzcolID:(int)yzcolID cjcolID:(int)cjcolID sgcolID:(int)sgcolID dsgcolID:(int)dsgcolID;

+(id)getSencePathBySIXID_yz:(int)roomID sfid:(int)sfid yzid:(int)yzid cjid:(int)cjid sgid:(int)sgid dsgid:(int)dsgid sfcolID:(int)sfcolID yzcolID:(int)yzcolID cjcolID:(int)cjcolID sgcolID:(int)sgcolID dsgcolID:(int)dsgcolID;

+(id)getSencePathBySIXID_cj:(int)roomID sfid:(int)sfid yzid:(int)yzid cjid:(int)cjid sgid:(int)sgid dsgid:(int)dsgid sfcolID:(int)sfcolID yzcolID:(int)yzcolID cjcolID:(int)cjcolID sgcolID:(int)sgcolID dsgcolID:(int)dsgcolID;

//yanse
+(id)getSencePathBySEVENID:(int)roomID sfid:(int)sfid yzid:(int)yzid cjid:(int)cjid sgid:(int)sgid dsgid:(int)dsgid sfcolID:(int)sfcolID yzcolID:(int)yzcolID cjcolID:(int)cjcolID sgcolID:(int)sgcolID dsgcolID:(int)dsgcolID;

+(id)getSencePathByID:(int)roomID sfid:(int)sfid colid:(int)colid;

+(id)getSencePathByID:(int)roomID yzid:(int)yzid colid:(int)colid;
+(id)getSencePathByID:(int)roomID cjid:(int)cjid colid:(int)colid;
//班台小图
+(id)getRoomTableThumb:(int)roomID;
//班台颜色小图
+(id)getRoomTableColorThumb:(int)tableID roomID:(int)roomID;
//班台path
+(id)getRoomTableDefaultPath:(int)tableID roomID:(int)roomID;

+(id)getRoomchaguishayiPathByTableID:(int)tableID typeID:(int)typeID roomID:(int)roomID;





+(id)getRoomTablePathByColor:(int)ColorID tableID:(int)tableID roomID:(int)roomID;
//茶柜小图
+(id)getRoomchaguiThumb:(int)roomID ID:(int)ID;

//xuni
+(id)getRoomchaguiThumb_xuni:(int)roomID ID:(int)ID tableID:(int)tableID;



+(id)getRoomchaguiColorThumb:(int)chaguiID;


//xuni
+(id)getRoomDefaultchaguiPath_xuni:(int)typeID roomID:(int)roomID tableID:(int)tableID;
//xuni
+(id)getRoomDefaultchaguiPath_xn:(int)typeID tableID:(int)tableID roomID:(int)roomID;


+(id)getRoomDefaultchaguiPath:(int)typeID roomID:(int)roomID;
+(id)getRoomDefaultchaguiPath:(int)typeID chaguiID:(int)chaguiID roomID:(int)roomID;

//xuni
+(id)getRoomDefaultshayiPath_xuni:(int)typeID roomID:(int)roomID tableID:(int)tableID;
//xuni
+(id)getRoomDefaultshayiPath_xn:(int)typeID tableID:(int)tableID roomID:(int)roomID;




+(id)getRoomDefaultshayiPath:(int)typeID roomID:(int)roomID;
+(id)getRoomDefaultshayiPath:(int)typeID shayiID:(int)shayiID roomID:(int)roomID;


+(id)getRoomchaguinewPath:(int)chaguiID;
+(id)getRoomchaguiPath:(int)chaguiID shayiID:(int)shayiID chajiID:(int)chajiID guiziID:(int)guiziID roomID:(int)roomID;


+(id)getRoomchaguiPath:(int)chaguiID;

+(id)getRoomshiyiPath:(int)shayiID shafaID:(int)shafaID yiziID:(int)yiziID roomID:(int)roomID;

+(id)getRoomshayiPath:(int)shayiID;

+(id)getRoomshayiAndChaguiPathbyColorID:(int)ColorID;


+(id)getRoomproduct:(int)proID;


//...................................................................................产品...................................................................................

+(id)getRoom:(int)roomID;
//取广告
+(id)getAdvert;

+(id)getProductWithAdvert;

+(id)getProductAllType;

+(id)getFilterWithTypeId:(NSNumber*)value type:(NSInteger*)type;

+(id)getProductWithTypeId:(NSNumber*)value keyword:(NSString*)keyword filter:(NSString*)filter;

+(id)getProductInId:(NSArray*)value;

+(id)getProductColorWithId:(NSNumber*)value;

+(id)getProductLeatherWithId:(NSNumber*)value;

+(id)getProductSpecificationWithId:(NSNumber*)value;

+(id)getProductAlbumWithId:(NSNumber*)value;

+(id)getProductSceneWithId:(NSNumber*)value;

+(id)getProductWithId:(NSNumber*)value;

+(id)getProductInRoomWithId:(NSNumber*)value;

//...................................................................................沙盘...................................................................................
//取沙盘商品规格
+(id)getSandBoxGoodsWithProductId:(NSString*)value;

+(id)getSandBoxGoodsPackageWithProductId:(NSString*)value;

+(id)openSandBoxWithCustomerId:(NSNumber*)customerId salesId:(NSNumber*)salesId;

+(void)saveSandBoxWithCustomerId:(NSNumber*)customerId salesId:(NSNumber*)salesId path:(NSString*)path name:(NSString*)name;
@end
