//
//  Access.m
//  ms
//
//  Created by mac on 12-12-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import "Access.h"
#import "Config.h"
#import "NSString+SBJSON.h"

@implementation Access

//..................................................................................电子书..................................................................................
+(id)getBrandstoryWithCategory:(NSNumber*)value
{
    NSString *sql = [NSString stringWithFormat:@"SELECT id,name,photo,file,fileType FROM brandstory WHERE deleted=0 AND category=%@",value];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getBrandstoryPictureWithId:(NSNumber*)value
{
    NSString *sql = [NSString stringWithFormat:@"SELECT photo,smallPhoto FROM brandstorypicture WHERE deleted=0 AND brandStory_id=%@ ORDER BY dispIndex",value];
    
    return [[SQL shareInstance] fetch:sql];
}

//..................................................................................样板房..................................................................................


+(id)Goproduct:(int)proID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM product WHERE deleted=0 AND id=%d",proID];
    
    return [[SQL shareInstance] fetch:sql];
}


+(id)getRoomPic
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE deleted=0 AND type!=1"];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getRoomPicByspaceType:(int)spaceType
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE deleted=0 AND type=%d",spaceType];
    
    return [[SQL shareInstance] fetch:sql];
}
+(id)getRoomPicByspaceTypeAndLevSize:(int)spaceType lev:(id)lev size:(id)size spaceid:(int)spaceid
{
    
    NSString *sql;
    
    if(spaceid==1)
    {
        if(lev!=nil)
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE deleted=0 AND level='%@' AND size='%@'  AND type=%d ",lev,size,spaceid];
        }
        else
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE deleted=0 AND size='%@'  AND type=%d ",size,spaceid];
        }
        
        
    }else 
    {
        
        if(lev!=nil)
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE deleted=0 AND level='%@' AND size='%@'  AND type!=1 ",lev,size];
        }
        else
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE deleted=0 AND size='%@'  AND type!=1 ",size];
        }
        
    }
    
    return [[SQL shareInstance] fetch:sql];
}




+(id)getRoomPicByspaceTypeAndLev:(int)spaceType lev:(id)lev spaceid:(int)spaceid
{
    NSString *sql;
    
    if(spaceid==1)
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE deleted=0 AND level='%@'  AND type=%d ",lev,spaceid];
    }else 
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE deleted=0 AND level='%@'  AND type!=1 ",lev];
    }
    
    return [[SQL shareInstance] fetch:sql];
}


+(id)getRoomPicByspaceTypeAndSize:(int)spaceType size:(id)size spaceid:(int)spaceid
{
    
    NSString *sql;
    
    if(spaceid==1)
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE deleted=0 AND size='%@'  AND type=%d ",size,spaceid];
    }else 
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE deleted=0 AND size='%@'  AND type!=1 ",size];
    }
    
    return [[SQL shareInstance] fetch:sql];
}


//

+(id)getRoomdefaultWallCapPath:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.viewPhoto1,b.viewPhoto2,b.viewPhoto3,b.viewPhoto4,b.wall_id,b.carpet_id "\
                     "FROM room a "\
                     "INNER JOIN roommapwallcarpet b ON a.id=b.room_id AND b.deleted=0  AND b.isDefault=1 "\
                     "WHERE a.deleted=0 AND b.room_id=%d ",roomID];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getRoomWallCapPath:(int)roomID wallID:(int)wallID capID:(int)capID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.viewPhoto1,b.viewPhoto2,b.viewPhoto3,b.viewPhoto4,b.wall_id,b.carpet_id "\
                     "FROM room a "\
                     "INNER JOIN roommapwallcarpet b ON a.id=b.room_id AND b.deleted=0 "\
                     "WHERE a.deleted=0 AND b.room_id=%d AND b.wall_id=%d AND b.carpet_id=%d ",roomID,wallID,capID];
    
    return [[SQL shareInstance] fetch:sql];
}


+(id) getwallThumb:(uint)roomID 
{
    NSString *sql = [NSString stringWithFormat:@"SELECT c.id,c.name model,c.photo "\
                     "FROM room AS a "\
                     "INNER JOIN roommapwallcarpet AS b ON b.deleted=0 AND a.id=b.room_id "\
                     "INNER JOIN wall AS c ON c.deleted=0 AND c.id = b.wall_id "\
                     "WHERE a.deleted=0 AND a.id=%d GROUP BY b.wall_id",roomID];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id) getcapThumb:(uint)roomID 
{
    NSString *sql = [NSString stringWithFormat:@"SELECT c.id,c.name,c.photo "\
                     "FROM room AS a "\
                     "INNER JOIN roommapwallcarpet AS b ON b.deleted=0 AND a.id=b.room_id "\
                     "INNER JOIN carpet AS c ON c.deleted=0 AND c.id = b.carpet_id "\
                     "WHERE a.deleted=0 AND a.id=%d GROUP BY b.carpet_id",roomID];
    
    return [[SQL shareInstance] fetch:sql];
    
}

//

+(id) getoneThumb:(uint)roomID 
{
    NSString *sql = [NSString stringWithFormat:@"SELECT c.* "\
                     "FROM room AS a "\
                     "INNER JOIN roommapproductpackage AS b ON b.deleted=0 AND a.id=b.room_id AND b.isDefault=1 "\
                     "INNER JOIN productpackage AS c ON c.deleted=0 AND c.id = b.productPackage_id "\
                     "WHERE a.deleted=0 AND a.id = %d",roomID];
    
    return [[SQL shareInstance] fetch:sql];
    
}


//实景样板房小图
+(id)getSenceRoomSFThumb:(int)roomID
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT b.product1_id id, c.photo,c.model "\
                     "FROM room AS a INNER JOIN roommapsceneproduct AS b ON a.id = b.room_id INNER JOIN product c ON b.product1_id=c.id "\
                     "WHERE a.deleted = 0 and b.deleted=0 and a.id=%d "\
                     "GROUP BY b.product1_id",roomID];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getSenceRoomYZThumb:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.product2_id id, c.photo,c.model "\
                     "FROM room AS a INNER JOIN roommapsceneproduct AS b ON a.id = b.room_id INNER JOIN product c ON b.product2_id=c.id "\
                     "WHERE a.deleted = 0 and b.deleted=0 and a.id=%d "\
                     "GROUP BY b.product2_id",roomID];
    
    //    NSString *sql = [NSString stringWithFormat:@"SELECT c.photo,c.id "\
    //                     "FROM room AS a "\
    //                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
    //                     "INNER JOIN product AS c ON c.deleted=0 AND b.product2_id=c.id "\
    //                     "WHERE a.deleted=0 AND a.id=2 GROUP BY b.product2_id",roomID];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getSenceRoomCJThumb:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.product3_id id, c.photo,c.model "\
                     "FROM room AS a INNER JOIN roommapsceneproduct AS b ON a.id = b.room_id INNER JOIN product c ON b.product3_id=c.id "\
                     "WHERE a.deleted = 0 and b.deleted=0 and a.id=%d "\
                     "GROUP BY b.product3_id",roomID];
    
    //    NSString *sql = [NSString stringWithFormat:@"SELECT c.photo,c.id "\
    //                     "FROM room AS a "\
    //                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
    //                     "INNER JOIN product AS c ON c.deleted=0 AND b.product3_id=c.id "\
    //                     "WHERE a.deleted=0 AND a.id=2 GROUP BY b.product3_id",roomID];
    
    return [[SQL shareInstance] fetch:sql];
}
+(id)getSenceRoomSGThumb:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.product4_id id, c.photo,c.model "\
                     "FROM room AS a INNER JOIN roommapsceneproduct AS b ON a.id = b.room_id INNER JOIN product c ON b.product4_id=c.id "\
                     "WHERE a.deleted = 0 and b.deleted=0 and a.id=%d "\
                     "GROUP BY b.product4_id",roomID];
    
    
    return [[SQL shareInstance] fetch:sql];
}
+(id)getSenceRoomDSGThumb:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.product5_id id, c.photo,c.model "\
                     "FROM room AS a INNER JOIN roommapsceneproduct AS b ON a.id = b.room_id INNER JOIN product c ON b.product5_id=c.id "\
                     "WHERE a.deleted = 0 and b.deleted=0 and a.id=%d "\
                     "GROUP BY b.product5_id",roomID];
    
    
    return [[SQL shareInstance] fetch:sql];
}





+(id)getSenceRoomSFColorThumbBypro:(int)roomID proID:(int)proID 
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT b.color1_id id, c.photo,c.name model,b.isDefault "\
                     "FROM roommapsceneproduct b INNER JOIN color c ON b.color1_id=c.id "\
                     "WHERE b.deleted=0 and c.deleted=0 and b.product1_id =%d AND b.room_id=%d "\
                     "GROUP BY b.color1_id",proID,roomID];
    
    
    //    NSString *sql = [NSString stringWithFormat:@"SELECT c.photo,c.id "\
    //                     "FROM room AS a "\
    //                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
    //                     "INNER JOIN color AS c ON c.deleted=0 AND b.color1_id=c.id "\
    //                     "WHERE a.deleted=0 AND a.id=%d AND b.product1_id=%d GROUP BY b.color1_id",roomID,proID];
    
    return [[SQL shareInstance] fetch:sql];
    
}


+(id)getSenceRoomYZColorThumbBypro:(int)roomID proID:(int)proID 
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.color2_id id, c.photo,c.name model "\
                     "FROM roommapsceneproduct b INNER JOIN color c ON b.color2_id=c.id "\
                     "WHERE b.deleted=0 and c.deleted=0 and b.product2_id =%d AND b.room_id=%d "\
                     "GROUP BY b.color2_id",proID,roomID];
    
    //    NSString *sql = [NSString stringWithFormat:@"SELECT c.photo,c.id "\
    //                     "FROM room AS a "\
    //                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
    //                     "INNER JOIN color AS c ON c.deleted=0 AND b.color2_id=c.id "\
    //                     "WHERE a.deleted=0 AND a.id=%d AND b.product2_id=%d GROUP BY b.color2_id",roomID,proID];
    
    return [[SQL shareInstance] fetch:sql];
    
}


+(id)getSenceRoomCJColorThumbBypro:(int)roomID proID:(int)proID 
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.color3_id id, c.photo,c.name model "\
                     "FROM roommapsceneproduct b INNER JOIN color c ON b.color3_id=c.id "\
                     "WHERE b.deleted=0 and c.deleted=0 and b.product3_id =%d AND b.room_id=%d "\
                     "GROUP BY b.color3_id",proID,roomID];
    //    NSString *sql = [NSString stringWithFormat:@"SELECT c.photo,c.id "\
    //                     "FROM room AS a "\
    //                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
    //                     "INNER JOIN color AS c ON c.deleted=0 AND b.color3_id=c.id "\
    //                     "WHERE a.deleted=0 AND a.id=%d AND b.product3_id=%d GROUP BY b.color3_id",roomID,proID];
    
    return [[SQL shareInstance] fetch:sql];
    
}

+(id)getSenceRoomSGColorThumbBypro:(int)roomID proID:(int)proID 
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT b.color4_id id, c.photo,c.name model "\
                     "FROM roommapsceneproduct b INNER JOIN color c ON b.color4_id=c.id "\
                     "WHERE b.deleted=0 and c.deleted=0 and b.product4_id =%d "\
                     "GROUP BY b.color4_id",proID];
    
    //    NSString *sql = [NSString stringWithFormat:@"SELECT c.photo,c.id "\
    //                     "FROM room AS a "\
    //                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
    //                     "INNER JOIN color AS c ON c.deleted=0 AND b.color4_id=c.id "\
    //                     "WHERE a.deleted=0 AND a.id=%d AND b.product4_id=%d GROUP BY b.color4_id",roomID,proID];
    
    return [[SQL shareInstance] fetch:sql];
    
}


+(id)getSenceRoomDSGColorThumbBypro:(int)roomID proID:(int)proID 
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT b.color5_id id, c.photo,c.name model "\
                     "FROM roommapsceneproduct b INNER JOIN color c ON b.color5_id=c.id "\
                     "WHERE b.deleted=0 and c.deleted=0 and b.product5_id =%d "\
                     "GROUP BY b.color5_id",proID];
    
    //    NSString *sql = [NSString stringWithFormat:@"SELECT c.photo,c.id "\
    //                     "FROM room AS a "\
    //                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
    //                     "INNER JOIN color AS c ON c.deleted=0 AND b.color5_id=c.id "\
    //                     "WHERE a.deleted=0 AND a.id=%d AND b.product5_id=%d GROUP BY b.color5_id",roomID,proID];
    
    return [[SQL shareInstance] fetch:sql];
    
}


+(id)getSenceDefaultPath:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.viewPhoto1,b.viewPhoto2,a.product_id,product1_id,product2_id,product3_id,product4_id,product5_id,color1_id,color2_id,color3_id,color4_id,color5_id "\
                     "FROM room AS a "\
                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id AND isDefault=1 "\
                     "WHERE a.deleted=0 AND a.id=%d ",roomID];
    
    return [[SQL shareInstance] fetch:sql];
    
}

//chanpin
+(id)getSencePathBySIXID_sf:(int)roomID sfid:(int)sfid yzid:(int)yzid cjid:(int)cjid sgid:(int)sgid dsgid:(int)dsgid sfcolID:(int)sfcolID yzcolID:(int)yzcolID cjcolID:(int)cjcolID sgcolID:(int)sgcolID dsgcolID:(int)dsgcolID
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT a.product_id, b.viewPhoto1,b.viewPhoto2,b.color1_id,b.color2_id,b.color3_id "\
                     "FROM room AS a "\
                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
                     "WHERE a.deleted=0 AND a.id=%d AND b.product1_id=%d AND b.product2_id=%d AND b.product3_id=%d AND b.color2_id=%d AND b.color3_id=%d ",roomID,sfid,yzid,cjid,yzcolID,cjcolID];
    
    return [[SQL shareInstance] fetch:sql];
    
}

+(id)getSencePathBySIXID_yz:(int)roomID sfid:(int)sfid yzid:(int)yzid cjid:(int)cjid sgid:(int)sgid dsgid:(int)dsgid sfcolID:(int)sfcolID yzcolID:(int)yzcolID cjcolID:(int)cjcolID sgcolID:(int)sgcolID dsgcolID:(int)dsgcolID
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT a.product_id,b.viewPhoto1,b.viewPhoto2,b.color1_id,b.color2_id,b.color3_id "\
                     "FROM room AS a "\
                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
                     "WHERE a.deleted=0 AND a.id=%d AND b.product1_id=%d AND b.product2_id=%d AND b.product3_id=%d AND b.color1_id=%d AND b.color3_id=%d ",roomID,sfid,yzid,cjid,sfcolID,cjcolID];
    
    return [[SQL shareInstance] fetch:sql];
    
}

+(id)getSencePathBySIXID_cj:(int)roomID sfid:(int)sfid yzid:(int)yzid cjid:(int)cjid sgid:(int)sgid dsgid:(int)dsgid sfcolID:(int)sfcolID yzcolID:(int)yzcolID cjcolID:(int)cjcolID sgcolID:(int)sgcolID dsgcolID:(int)dsgcolID
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT a.product_id,b.viewPhoto1,b.viewPhoto2,b.color1_id,b.color2_id,b.color3_id "\
                     "FROM room AS a "\
                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
                     "WHERE a.deleted=0 AND a.id=%d AND b.product1_id=%d AND b.product2_id=%d AND b.product3_id=%d AND b.color1_id=%d AND b.color2_id=%d ",roomID,sfid,yzid,cjid,sfcolID,yzcolID];
    
    return [[SQL shareInstance] fetch:sql];
    
}

//yanse
+(id)getSencePathBySEVENID:(int)roomID sfid:(int)sfid yzid:(int)yzid cjid:(int)cjid sgid:(int)sgid dsgid:(int)dsgid sfcolID:(int)sfcolID yzcolID:(int)yzcolID cjcolID:(int)cjcolID sgcolID:(int)sgcolID dsgcolID:(int)dsgcolID
{
    
    
    NSString *sql = [NSString stringWithFormat:@"SELECT a.product_id,b.viewPhoto1,b.viewPhoto2,b.color1_id,b.color2_id,b.color3_id "\
                     "FROM room AS a "\
                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
                     "WHERE a.deleted=0 AND a.id=%d AND b.product1_id=%d AND b.product2_id=%d AND b.product3_id=%d AND b.color1_id=%d AND b.color2_id=%d AND b.color3_id=%d ",roomID,sfid,yzid,cjid,sfcolID,yzcolID,cjcolID];
    
    return [[SQL shareInstance] fetch:sql];
    
}






+(id)getSencePathByID:(int)roomID sfid:(int)sfid colid:(int)colid 
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.viewPhoto1,b.viewPhoto2 "\
                     "FROM room AS a "\
                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
                     "WHERE a.deleted=0 AND a.id=%d AND b.product1_id=%d AND b.color1_id=%d ",roomID,sfid,colid];
    
    return [[SQL shareInstance] fetch:sql];
    
}

+(id)getSencePathByID:(int)roomID yzid:(int)yzid colid:(int)colid 
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.viewPhoto1,b.viewPhoto2 "\
                     "FROM room AS a "\
                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
                     "WHERE a.deleted=0 AND a.id=%d AND b.product2_id=%d AND b.color2_id=%d ",roomID,yzid,colid];
    
    return [[SQL shareInstance] fetch:sql];
    
}

+(id)getSencePathByID:(int)roomID cjid:(int)cjid colid:(int)colid 
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.viewPhoto1,b.viewPhoto2 "\
                     "FROM room AS a "\
                     "INNER JOIN roommapsceneproduct AS b ON b.deleted=0 AND a.id=b.room_id "\
                     "WHERE a.deleted=0 AND a.id=%d AND b.product3_id=%d AND b.color3_id=%d ",roomID,cjid,colid];
    
    return [[SQL shareInstance] fetch:sql];
    
}







//班台小图
+(id)getRoomTableThumb:(int)roomID
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT c.photo,c.id,c.model  "\
                     "FROM room AS a "\
                     "INNER JOIN roommaptable AS b ON b.deleted=0 AND a.id=b.room_id "\
                     "INNER JOIN product AS c ON c.deleted=0 AND b.product_id=c.id "\
                     "WHERE a.deleted=0 AND b.room_id=%d",roomID];
    
    return [[SQL shareInstance] fetch:sql];
}
//班台颜色小图
+(id)getRoomTableColorThumb:(int)tableID roomID:(int)roomID
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT b.photo,b.id,b.name model "\
                     "FROM roommaptable AS a "\
                     "INNER JOIN roomtablemapcolor AS c ON c.deleted=0 AND a.id = c.roomMapTable_id "\
                     "INNER JOIN color AS b ON b.deleted=0 AND c.color_id=b.id "\
                     "WHERE a.deleted=0 AND a.product_id=%d and a.room_id = %d",tableID,roomID];
    
    return [[SQL shareInstance] fetch:sql];
}
//班台path
+(id)getRoomTableDefaultPath:(int)tableID roomID:(int)roomID{
    
    NSString *sql;
    
    if(tableID > 0){
        
        sql = [NSString stringWithFormat:@"SELECT a.product_id id,b.viewPhoto1,b.viewPhoto2,b.viewPhoto3,b.viewPhoto4,b.color_id "\
               "FROM roommaptable AS a "\
               "INNER JOIN roomtablemapcolor AS b ON b.deleted=0 AND a.id=b.roomMapTable_id AND b.isDefault=1 "\
               "WHERE a.deleted=0 AND a.product_id=%d AND a.room_id=%d ",tableID,roomID];
    }
    else 
    {
        sql = [NSString stringWithFormat:@"SELECT a.product_id id,b.viewPhoto1,b.viewPhoto2,b.viewPhoto3,b.viewPhoto4,b.color_id  "\
               "FROM roommaptable AS a "\
               "INNER JOIN roomtablemapcolor AS b ON b.deleted=0 AND a.id=b.roomMapTable_id AND b.isDefault=1 "\
               "WHERE a.deleted=0 AND a.isDefault=1 AND a.room_id=%d ",roomID];
    }
    
    
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getRoomchaguishayiPathByTableID:(int)tableID typeID:(int)typeID roomID:(int)roomID{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id id,b.viewPhoto1,b.viewPhoto2,b.viewPhoto3,b.viewPhoto4,a.product1_id,a.product2_id,b.color1_id,b.color2_id  "\
                     "FROM roommapproduct AS a "\
                     "INNER JOIN roomproductmapcolor AS b ON b.deleted=0 AND a.id=b.roomMapProduct_id AND b.isDefault=1 "\
                     "WHERE a.deleted=0 AND a.product_id=%d AND a.type=%d AND a.room_id=%d ORDER BY b.id  ",tableID,typeID,roomID];
    
    return [[SQL shareInstance] fetch:sql];
}





+(id)getRoomTablePathByColor:(int)ColorID tableID:(int)tableID roomID:(int)roomID
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT b.viewPhoto1,b.viewPhoto2,b.viewPhoto3,b.viewPhoto4 "\
                     "FROM roommaptable AS a "\
                     "INNER JOIN roomtablemapcolor AS b ON b.deleted=0 AND a.id=b.roomMapTable_id "\
                     "WHERE a.deleted=0 AND a.product_id=%d AND b.color_id = %d AND a.room_id=%d",tableID,ColorID,roomID];
    
    return [[SQL shareInstance] fetch:sql];
}

//茶柜小图
+(id)getRoomchaguiThumb:(int)roomID ID:(int)ID
{
    
    //NSString *sql = [NSString stringWithFormat:@"SELECT id,photo FROM roommapproduct WHERE room_id=%d AND type=%d AND deleted=0",roomID,ID];
    
    
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id,a.photo,b.model "\
                     "FROM roommapproduct as a "\
                     "INNER JOIN product AS b ON b.deleted=0 AND b.id = a.product1_id  "\
                     "WHERE a.room_id=%d AND a.type=%d AND a.deleted=0",roomID,ID];
    
    
    
    
    return [[SQL shareInstance] fetch:sql];
}

//xuni
+(id)getRoomchaguiThumb_xuni:(int)roomID ID:(int)ID tableID:(int)tableID
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id,a.photo,b.model,a.product1_id,a.product2_id  "\
                     "FROM roommapproduct as a "\
                     "INNER JOIN product AS b ON b.deleted=0 AND b.id = a.product1_id  "\
                     "WHERE a.room_id=%d AND a.type=%d AND a.deleted=0 AND a.product_id=%d",roomID,ID,tableID];
    
    return [[SQL shareInstance] fetch:sql];
}



+(id)getRoomchaguiColorThumb:(int)chaguiID
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT tmp.color1_id, tmp.color2_id, b.photo,b.id,b.name model "\
                     "FROM ( "\
                     "SELECT color1_id, color2_id "\
                     "FROM roomproductmapcolor "\
                     "WHERE roomMapProduct_id=%d and deleted = 0 "\
                     "GROUP BY color1_id, color2_id) tmp INNER JOIN color b ON tmp.color2_id=b.id and b.deleted=0 GROUP BY id ",chaguiID];
    
    return [[SQL shareInstance] fetch:sql];
}


//xuni
+(id)getRoomDefaultchaguiPath_xuni:(int)typeID roomID:(int)roomID tableID:(int)tableID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id,b.viewPhoto1, b.viewPhoto2,b.color1_id,b.color2_id,a.product1_id,a.product2_id "\
                     "FROM roommapproduct AS a "\
                     "INNER JOIN roomproductmapcolor AS b ON b.deleted=0 and b.roomMapProduct_id=a.id AND b.isDefault=1 "\
                     "WHERE a.deleted=0 AND a.type=%d AND a.isDefault=1 and a.room_id = %d and includeMapProduct_id NOT NULL AND a.product_id=%d ",typeID,roomID,tableID];
    
    return [[SQL shareInstance] fetch:sql];
    
}
//xuni
+(id)getRoomDefaultchaguiPath_xn:(int)typeID tableID:(int)tableID roomID:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id,b.viewPhoto1, b.viewPhoto2,b.color1_id,b.color2_id,a.product1_id,a.product2_id "\
                     "FROM roommapproduct AS a "\
                     "INNER JOIN roomproductmapcolor AS b ON b.deleted=0 and b.roomMapProduct_id=a.id AND b.isDefault=1 "\
                     "WHERE a.deleted=0 AND a.type=%d AND a.isDefault=1 and a.room_id = %d and includeMapProduct_id ISNULL AND a.product_id=%d ",typeID,roomID,tableID];
    
    return [[SQL shareInstance] fetch:sql];
    
}


+(id)getRoomDefaultchaguiPath:(int)typeID roomID:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id,b.viewPhoto1, b.viewPhoto2,b.viewPhoto3,b.viewPhoto4,a.product1_id,a.product2_id,b.color1_id,b.color2_id "\
                     "FROM roommapproduct AS a "\
                     "INNER JOIN roomproductmapcolor AS b ON b.deleted=0 and b.roomMapProduct_id=a.id AND b.isDefault=1 "\
                     "WHERE a.deleted=0 AND a.type=%d AND a.isDefault=1 and a.room_id = %d and includeMapProduct_id NOTNULL ",typeID,roomID];
    
    return [[SQL shareInstance] fetch:sql];
    
}
+(id)getRoomDefaultchaguiPath:(int)typeID chaguiID:(int)chaguiID roomID:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id,b.viewPhoto1, b.viewPhoto2,b.color1_id,b.color2_id "\
                     "FROM roommapproduct AS a "\
                     "INNER JOIN roomproductmapcolor AS b ON b.deleted=0 and b.roomMapProduct_id=a.id AND b.isDefault=1 "\
                     "WHERE a.deleted=0 AND a.type=%d AND a.isDefault=1 and a.room_id = %d and includeMapProduct_id ISNULL ",typeID,roomID];
    
    return [[SQL shareInstance] fetch:sql];
    
}

//xuni
+(id)getRoomDefaultshayiPath_xuni:(int)typeID roomID:(int)roomID tableID:(int)tableID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id ,b.viewPhoto1, b.viewPhoto2,b.color1_id,b.color2_id,a.product1_id,a.product2_id  "\
                     "FROM roommapproduct AS a "\
                     "INNER JOIN roomproductmapcolor AS b ON b.deleted=0 and b.roomMapProduct_id=a.id AND b.isDefault=1 "\
                     "WHERE a.deleted=0 AND a.type=%d AND a.isDefault=1 and a.room_id = %d and includeMapProduct_id NOTNULL AND a.product_id=%d  ",typeID,roomID,tableID];
    
    return [[SQL shareInstance] fetch:sql];
    
}
//xuni
+(id)getRoomDefaultshayiPath_xn:(int)typeID tableID:(int)tableID roomID:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id ,b.viewPhoto1, b.viewPhoto2,b.color1_id,b.color2_id,a.product1_id,a.product2_id "\
                     "FROM roommapproduct AS a "\
                     "INNER JOIN roomproductmapcolor AS b ON b.deleted=0 and b.roomMapProduct_id=a.id AND b.isDefault=1 "\
                     "WHERE a.deleted=0 AND a.type=%d AND a.isDefault=1 and a.room_id = %d and includeMapProduct_id ISNULL AND a.product_id=%d ",typeID,roomID,tableID];
    
    return [[SQL shareInstance] fetch:sql];
    
}




+(id)getRoomDefaultshayiPath:(int)typeID roomID:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id ,b.viewPhoto1, b.viewPhoto2,b.viewPhoto3,b.viewPhoto4,a.product1_id,a.product2_id,b.color1_id,b.color2_id "\
                     "FROM roommapproduct AS a "\
                     "INNER JOIN roomproductmapcolor AS b ON b.deleted=0 and b.roomMapProduct_id=a.id AND b.isDefault=1 "\
                     "WHERE a.deleted=0 AND a.type=%d AND a.isDefault=1 and a.room_id = %d and includeMapProduct_id NOTNULL  ",typeID,roomID];
    
    return [[SQL shareInstance] fetch:sql];
    
}
+(id)getRoomDefaultshayiPath:(int)typeID shayiID:(int)shayiID roomID:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id ,b.viewPhoto1, b.viewPhoto2,b.viewPhoto3,b.viewPhoto4,a.product1_id,a.product2_id,b.color1_id,b.color2_id "\
                     "FROM roommapproduct AS a "\
                     "INNER JOIN roomproductmapcolor AS b ON b.deleted=0 and b.roomMapProduct_id=a.id AND b.isDefault=1 "\
                     "WHERE a.deleted=0 AND a.type=%d AND a.isDefault=1 and a.room_id = %d and includeMapProduct_id ISNULL ",typeID,roomID];
    
    return [[SQL shareInstance] fetch:sql];
    
}


+(id)getRoomchaguinewPath:(int)chaguiID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT viewPhoto1, viewPhoto2,viewPhoto3,viewPhoto4,includeMapProduct_id "\
                     "FROM roomproductmapcolor "\
                     "WHERE roomMapProduct_id=%d",chaguiID];
    
    return [[SQL shareInstance] fetch:sql];
}




//path   -----------


//SELECT viewPhoto1, viewPhoto2
//FROM roomproductmapcolor
//WHERE includeMapProduct_id=%d and roomMapProduct_id=%d and color1_id=%d and color2_id=%
//
//
//SELECT viewPhoto1, viewPhoto2
//FROM roomproductmapcolor
//WHERE roomMapProduct_id=%d and color1_id=%d and color2_id=%





+(id)getRoomchaguiPath:(int)chaguiID shayiID:(int)shayiID chajiID:(int)chajiID guiziID:(int)guiziID roomID:(int)roomID
{
    NSString *sql;
    
    if(guiziID>0)
    {
        //sql = [NSString stringWithFormat:@"SELECT  roomMapProduct_id id,viewPhoto1, viewPhoto2,viewPhoto3,viewPhoto4 "\
        "FROM roomproductmapcolor "\
        "WHERE includeMapProduct_id=%d and roomMapProduct_id=%d and color1_id=%d and color2_id=%d ",shayiID,chaguiID,chajiID,guiziID];
        
        sql = [NSString stringWithFormat:@"SELECT  a.roomMapProduct_id id,a.viewPhoto1, a.viewPhoto2,a.viewPhoto3,a.viewPhoto4,b.product1_id,b.product2_id,a.color1_id,a.color2_id "\
               "FROM roomproductmapcolor as a "\
               "INNER JOIN roommapproduct AS b ON b.deleted = 0 AND b.id = a.roomMapProduct_id "\
               "WHERE a.includeMapProduct_id=%d and a.roomMapProduct_id=%d and a.color1_id=%d and a.color2_id=%d and a.deleted = 0 and b.room_id=%d  ",shayiID,chaguiID,chajiID,guiziID,roomID];
    }
    else 
    {
        sql = [NSString stringWithFormat:@"SELECT  a.roomMapProduct_id id, a.viewPhoto1, a.viewPhoto2,a.viewPhoto3,a.viewPhoto4,b.product1_id,b.product2_id "\
               "FROM roomproductmapcolor as a "\
               "INNER JOIN roommapproduct AS b ON b.deleted = 0 AND b.id = a.roomMapProduct_id "\
               "WHERE a.includeMapProduct_id=%d and a.roomMapProduct_id=%d and a.color1_id=%d and a.deleted = 0 and b.room_id=%d ",shayiID,chaguiID,chajiID,roomID];
    }
    
    return [[SQL shareInstance] fetch:sql];
}


+(id)getRoomchaguiPath:(int)chaguiID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT viewPhoto1, viewPhoto2,viewPhoto3,viewPhoto4 "\
                     "FROM roomproductmapcolor "\
                     "WHERE roomMapProduct_id=%d AND isDefault=1",chaguiID];
    
    return [[SQL shareInstance] fetch:sql];
}



//



+(id)getRoomshiyiPath:(int)shayiID shafaID:(int)shafaID yiziID:(int)yiziID roomID:(int)roomID
{
    //NSString *sql = [NSString stringWithFormat:@"SELECT roomMapProduct_id id,viewPhoto1, viewPhoto2,viewPhoto3,viewPhoto4 "\
    "FROM roomproductmapcolor "\
    "WHERE roomMapProduct_id=%d and color1_id=%d and color2_id=%d ",shayiID,shafaID,yiziID];
    
    
    NSString *sql = [NSString stringWithFormat:@"SELECT a.roomMapProduct_id id,a.viewPhoto1, a.viewPhoto2,a.viewPhoto3,a.viewPhoto4,b.product1_id,b.product2_id "\
                     "FROM roomproductmapcolor as a "\
                     "INNER JOIN roommapproduct AS b ON b.deleted = 0 AND b.id = a.roomMapProduct_id "\
                     "WHERE a.roomMapProduct_id=%d and a.deleted=0 and a.color1_id=%d and a.color2_id=%d and b.room_id=%d ",shayiID,shafaID,yiziID,roomID];
    
    return [[SQL shareInstance] fetch:sql];
}


+(id)getRoomshayiPath:(int)shayiID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT viewPhoto1, viewPhoto2,viewPhoto3,viewPhoto4 "\
                     "FROM roomproductmapcolor "\
                     "WHERE roomMapProduct_id=%d AND isDefault=1",shayiID];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getRoomshayiAndChaguiPathbyColorID:(int)ColorID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT viewPhoto1, viewPhoto2,viewPhoto3,viewPhoto4 FROM roomproductmapcolor AS a WHERE a.deleted=0 AND a.id = %d",ColorID];
    
    return [[SQL shareInstance] fetch:sql];
    
}

+(id)getRoomproduct:(int)proID
{
    // NSString *sql = [NSString stringWithFormat:@"SELECT a.photo,a.id,a.model,a.size FROM product AS a WHERE a.deleted=0 AND a.id=%d",proID];
    
    /*NSString *sql = [NSString stringWithFormat:@"SELECT a.price price,a.photo,a.id,a.model,a.size,b.color_id colorId,c.leather_id leatherId,d.id specId "\
                     "FROM product AS a "\
                     "INNER JOIN productmapcolor AS b ON b.product_id = a.id AND b.deleted = 0 "\
                     "INNER JOIN productmapleather AS c ON c.product_id = a.id AND c.deleted = 0 "\
                     "INNER JOIN specifications AS d ON d.deleted = 0 AND d.product_id=a.id "\
                     "WHERE a.deleted=0 AND a.id=%d",proID];*/
    
    NSString *sql = [NSString stringWithFormat:@"SELECT a.price price,a.photo,a.id,a.model,a.size,b.color_id colorId,d.id specId FROM product AS a "\
                     "INNER JOIN productmapcolor AS b ON b.product_id = a.id AND b.deleted = 0 "\
                     "INNER JOIN specifications AS d ON d.deleted = 0 AND d.product_id=a.id WHERE a.deleted=0 AND a.id=%d GROUP BY specId",proID];
    
    return [[SQL shareInstance] fetch:sql];
}




//...................................................................................产品...................................................................................




+(id)getRoom:(int)roomID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM room WHERE id = %d",roomID];
    
    return [[SQL shareInstance] fetch:sql];
}
//取广告
+(id)getAdvert
{
    NSString *sql = [NSString stringWithFormat:@"SELECT photo FROM advertphoto WHERE deleted=0 ORDER BY dispIndex DESC"];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getProductWithAdvert
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.* FROM advertproduct a,product b WHERE b.deleted=0 AND b.id=a.product_id  AND a.deleted=0 GROUP BY b.id ORDER BY a.dispIndex DESC"];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getProductAllType
{
    NSString *sql = [NSString stringWithFormat:@"SELECT id,photo,name FROM producttype WHERE deleted=0 AND parent_id isNull"];
    
    /*NSArray *temp = [[SQL shareInstance] fetch:sql];
     
     for (NSMutableDictionary *dic in temp)
     {
     sql = [NSString stringWithFormat:@"SELECT id,photo,name FROM producttype WHERE deleted=0 AND parent_id=%@",[dic objectForKey:@"id"]];
     
     id subValue = [[SQL shareInstance] fetch:sql];
     
     if (subValue)
     {
     [dic setValue:subValue forKey:@"children"];
     }
     }
     
     return temp
     */
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getFilterWithTypeId:(NSNumber*)value type:(NSInteger*)type
{
    NSMutableArray *filter = [NSMutableArray array];

    NSString *sql = [NSString stringWithFormat:@"SELECT DISTINCT id,name FROM producttype WHERE deleted=0 AND parent_id=%@",value];
    
    id function = [[SQL shareInstance] fetch:sql];
    
    if (nil != function)
    {
        sql = [NSString stringWithFormat:@"SELECT DISTINCT b.id,b.name FROM product a,pneumatic b WHERE b.deleted=0 AND b.id=a.pneumatic_id AND a.deleted=0 AND a.pneumatic_id NOTNULL AND a.productType_id=%@",value];
        
        id pneumatic = [[SQL shareInstance] fetch:sql];
        
        if (pneumatic)
        {
            sql = [NSString stringWithFormat:@"SELECT DISTINCT b.id,b.name FROM product a,letter b WHERE b.deleted=0 AND b.id=a.letter_id AND a.deleted=0 AND a.letter_id NOTNULL AND a.productType_id=%@",value];
            
            id letter = [[SQL shareInstance] fetch:sql];
            
            if (letter)
            {
                NSMutableDictionary *dic0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:2],@"id",
                                      [NSNumber numberWithBool:YES],@"single",
                                      @"按字母型号分",@"name",
                                      letter,@"value",nil];
                
                [filter addObject:dic0];
                //
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:3],@"id",
                                     [NSNumber numberWithBool:YES],@"single",
                                     @"按汽动固定分",@"name",
                                     pneumatic,@"value",nil];
                
                [filter addObject:dic1];
                //
                NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:1],@"id",
                                      [NSNumber numberWithBool:NO],@"single",
                                      @"按功能用途分",@"name",
                                      function,@"value",nil];
                
                [filter addObject:dic2];
                
                *type = 0;
                
                return filter;
            }
        }
    }

    //取材质
    sql = [NSString stringWithFormat:@"SELECT DISTINCT b.id,b.name FROM product a,material b WHERE "\
           "b.deleted=0 AND b.id=a.material_id AND a.deleted=0 AND a.material_id NOTNULL AND a.productType_id=%@",value];
    
    NSArray *material = [[SQL shareInstance] fetch:sql];
    
    if (material)
    {
        //规格
        for (NSMutableDictionary *dic in material)
        {
            sql = [NSString stringWithFormat:@"SELECT DISTINCT b.id,b.name FROM product a,size b WHERE "\
                   "b.deleted=0 AND b.id=a.size_id AND a.deleted=0 AND a.size_id NOTNULL AND a.material_id=%@ AND a.productType_id=%@",[dic objectForKey:@"id"],value];
            
            [dic setValue:[[SQL shareInstance] fetch:sql] forKey:@"value"];
            
            [dic setValue:[NSNumber numberWithBool:YES] forKey:@"single"];
            
            [dic removeObjectForKey:@"materialId"];
        }
        
        *type = 1;
        
        return material;
    }

    //规格
    sql = [NSString stringWithFormat:@"SELECT DISTINCT b.id,b.name FROM product a,size b WHERE "\
           "b.deleted=0 AND b.id=a.size_id AND a.deleted=0 AND a.size_id NOTNULL AND a.productType_id=%@",value];
    
    *type = 2;
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getProductWithTypeId:(NSNumber*)value keyword:(NSString*)keyword filter:(NSString*)filter
{
    if (value) 
    {
        if (filter)
        {
            NSString *sql = [NSString stringWithFormat:@"SELECT a.*,b.name function FROM product a,producttype b WHERE "\
                             "b.deleted=0 AND b.id=a.productType_id AND a.deleted=0 AND a.productType_id=%@ %@",value,filter];
            
            return [[SQL shareInstance] fetch:sql];
        }
        
        if (keyword) 
        {
            NSString *sql = [NSString stringWithFormat:@"SELECT a.*,b.name function FROM product a,producttype b WHERE "\
                             "b.deleted=0 AND b.id=a.productType_id AND a.deleted=0 AND a.productType_id=%@ AND a.model LIKE '%%%@%%'",value,keyword];
            
            return [[SQL shareInstance] fetch:sql];
        }
    }
    
    if (keyword) 
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT a.*,b.name function FROM product a,producttype b WHERE "\
                         "b.deleted=0 AND b.id=a.productType_id AND a.deleted=0 AND a.model LIKE '%%%@%%'",keyword];
        
        return [[SQL shareInstance] fetch:sql];
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT a.*,b.name function FROM product a,producttype b WHERE "\
                     "b.deleted=0 AND b.id=a.productType_id AND a.deleted=0 AND a.productType_id=%@",value];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getProductInId:(NSArray*)value
{
    if (nil != value)
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT a.*,b.name function FROM product a,producttype b WHERE "\
                         "b.deleted=0 AND b.id=a.productType_id AND a.deleted=0 AND a.id IN %@",value];
        
        return [[SQL shareInstance] fetch:sql];
    }
    
    return nil;
}

+(id)getProductColorWithId:(NSNumber*)value
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.id,b.name,b.photo,a.price FROM productmapcolor a,color b WHERE "\
                     "b.deleted=0 AND b.id=a.color_id AND a.deleted=0 AND a.product_id=%@",value];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getProductLeatherWithId:(NSNumber*)value
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.id,b.name,b.photo FROM productmapleather a,leather b WHERE "\
                     "b.deleted=0 AND b.id=a.leather_id AND a.deleted=0 AND a.product_id=%@",value];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getProductSpecificationWithId:(NSNumber*)value
{
    NSString *sql = [NSString stringWithFormat:@"SELECT id,name,photo,price FROM specifications WHERE deleted=0 AND product_id=%@",value];

    return [[SQL shareInstance] fetch:sql];
}

+(id)getProductAlbumWithId:(NSNumber*)value
{
    NSString *sql = [NSString stringWithFormat:@"SELECT smallPhoto,bigPhoto FROM productpicture WHERE deleted=0 AND product_id=%@ ORDER BY isDefault DESC",value];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getProductSceneWithId:(NSNumber*)value
{
    NSString *sql = [NSString stringWithFormat:@"SELECT smallPhoto,bigPhoto FROM scenepicture WHERE deleted=0 AND product_id=%@",value];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)getProductWithId:(NSNumber*)value
{
    NSString *sql = [NSString stringWithFormat:@"SELECT id,name FROM productpackage WHERE deleted=0 AND product_id=%@",value];
    
    NSArray *tmp = [[SQL shareInstance] fetch:sql];
    
    for (NSMutableDictionary *package in tmp)
    {
        //取商品
        sql = [NSString stringWithFormat:@"SELECT b.id,b.name,c.name colorcase,d.name specifications,e.photo FROM productpackagegoods a "\
               "INNER JOIN goods b,colorcase c,specifications d,product e ON "\
               "b.deleted=0 AND b.id=a.goods_id AND "\
               "c.deleted=0 AND c.id=b.colorCase_id AND "\
               "d.deleted=0 AND d.id=b.spec_id AND "\
               "e.deleted=0 AND e.id=b.product_id "\
               "WHERE a.deleted=0 AND a.productPackage_id=%@",[package objectForKey:@"id"]];
        
        [package setValue:[[SQL shareInstance] fetch:sql] forKey:@"goods"];
    }
    
    return tmp;
}

+(id)getProductInRoomWithId:(NSNumber*)value
{
    /*NSString *sql = [NSString stringWithFormat:@"SELECT id,type FROM room WHERE deleted=0 AND id IN "\
                     "(SELECT DISTINCT room_id FROM roommapproduct WHERE deleted=0 AND (product_id=%@ OR product1_id=%@ OR product2_id=%@))",value,value,value];*/
    
    NSString *sql = [NSString stringWithFormat:@"SELECT id,type,photo,name FROM room WHERE deleted=0 AND id IN "\
                     "(SELECT DISTINCT room_id FROM productmaproom WHERE deleted=0 AND product_id=%@)",value];
    
    return [[SQL shareInstance] fetch:sql];
}



































//...................................................................................沙盘...................................................................................
//取沙盘商品规格
+(id)getSandBoxGoodsWithProductId:(NSString*)value
{
    //b.id*1000000+a.id id
    NSString *sql = [NSString stringWithFormat:@"SELECT a.name,b.photo,a.sandboxPhoto,b.id*10000+a.id id, b.price FROM specifications a,product b WHERE "\
                     "b.deleted=0 AND b.id=a.product_id AND a.deleted=0 AND a.sandboxPhoto NOTNULL AND a.product_id IN (%@)",value];
    
    return [[SQL shareInstance] fetch:sql];
}
//组合产品
+(id)getSandBoxGoodsPackageWithProductId:(NSString*)value
{
    //b.id*1000000+a.id id
    NSString *sql = [NSString stringWithFormat:@"SELECT b.name,c.photo,b.sandboxPhoto,c.id*10000+b.id id,c.price FROM productpackagemapproduct a,specifications b,product c WHERE "\
                     "c.deleted=0 AND c.id=a.product_id AND b.deleted=0 AND b.id=a.product_id AND b.sandboxPhoto NOTNULL AND a.deleted=0 AND a.product_id IN (%@)",value];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)openSandBoxWithCustomerId:(NSString*)customerId salesId:(NSNumber*)salesId
{
    //b.id*1000000+a.id id
    NSString *sql = [NSString stringWithFormat:@"SELECT id,name,file FROM sandboxcase WHERE customerId='%@' AND usersId=%@",customerId,salesId];
    
    NSArray *tmp = [[SQL shareInstance] fetch:sql];
    
    for (NSMutableDictionary *sandboxcase in tmp)
    {
        //取商品
        sql = [NSString stringWithFormat:@"SELECT a.productId*10000+a.specificationsId id,b.price,b.model name,d.id colorId,d.name colorcase,e.id specId,e.name specifications,b.photo,e.sandboxPhoto "\
               "FROM sandboxcaseproduct a, product b, productmapcolor c, color d, specifications e "\
               "WHERE e.deleted=0 AND e.id=a.specificationsId "\
               "AND d.deleted=0 AND d.id=c.color_id "\
               "AND c.deleted=0 AND c.product_id=a.productId "\
               "AND b.deleted=0 AND b.id=a.productId "\
               "AND a.sandboxCaseId='%@' AND e.sandboxPhoto NOTNULL GROUP BY id",[sandboxcase objectForKey:@"id"]];
        
        [sandboxcase setValue:[[SQL shareInstance] fetch:sql] forKey:@"goods"];
    }
    
    return tmp;
}

+(void)saveSandBoxWithCustomerId:(NSNumber*)customerId salesId:(NSNumber*)salesId path:(NSString*)path name:(NSString*)name
{
    NSString *fileName = [path lastPathComponent];
    
    NSString *sid = [fileName stringByDeletingPathExtension];
    
    NSString *sql = [NSString stringWithFormat:@"REPLACE INTO sandboxcase (id,name,customerId,usersId,createDate,file) "\
                     "VALUES ('%@','%@','%@',%@,datetime('now','+8 hours'),'%@')",sid, name, customerId, salesId, [@"file" stringByAppendingPathComponent:fileName]];
    
    [[SQL shareInstance] query:sql];
    
    //保存产品
    NSData *dat = [NSData dataWithContentsOfFile:path];
    
    if (dat)
    {
        id value = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableContainers error:nil];
        
        if (value)
        {
            //统计数量
            NSArray *objs = [value objectForKey:@"objs"];
            
            NSMutableDictionary *temp = [NSMutableDictionary dictionary];
            
            for (NSDictionary *product in objs)
            {
                NSNumber *pid = [product objectForKey:@"id"];
                
                if ([temp objectForKey:pid])
                {
                    NSInteger val = [[temp objectForKey:pid] intValue] + 1;
                    
                    [temp setObject:[NSNumber numberWithInt:val] forKey:pid];
                }
                else
                {
                    [temp setObject:[NSNumber numberWithInt:1] forKey:pid];
                }
            }
            
            //写入数据库
            NSString *gid = nil;
            
            for (NSNumber *key in [temp allKeys])
            {
                int proId = [key intValue] / 10000;
                
                int speId = [key intValue] - proId * 10000;
                
                sql = [NSString stringWithFormat:@"SELECT id FROM sandboxcaseproduct WHERE sandboxCaseId='%@' AND specificationsId=%d AND productId=%d LIMIT 0,1",sid,speId,proId];
                
                NSArray *source = [[SQL shareInstance] fetch:sql];
                
                if (source)
                {
                    gid = [[source lastObject] objectForKey:@"id"];
                }
                else 
                {
                    gid = [Utils uuid];
                }
                
                sql = [NSString stringWithFormat:@"REPLACE INTO sandboxcaseproduct (id,sandboxCaseId,specificationsId,productId,amount) "\
                       "VALUES ('%@','%@',%d,%d,%@)",gid, sid, speId, proId, [temp objectForKey:key]];
                
                [[SQL shareInstance] query:sql];
            }
        }
    }
}

@end
