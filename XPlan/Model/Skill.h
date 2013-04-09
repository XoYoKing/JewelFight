//
//  Skill.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 技能
@interface Skill : NSObject
{
    int skillId; // 技能标识
    NSString *name; // 技能名称
    int requiredLevel; // 等级需求
    int schoolId; // 门派
    int effectTarget; // 作用目标 1:自身 2:队友 4:敌人
    int skillArea; // 技能范围
    int continueTime; // 技能生效时间
    int happenFrequence; // 触发间隔
    int coldTime; // 冷却时间
    int coldGroup; // 冷却组
    int cost; // 技能消耗
    int iconId; // 技能图标标识
    
    NSString *skillEffect1; // 施法特效素材1
    int effectPosition1; // 施法位置 1:头顶 2:胸口 3:脚下
    NSString *skillEffect2; // 施法特效素材2
    int effectPosition2;
    NSString *skillEffect3; // 施法特效素材3
    int effectPosition3;
    int targetType; // 目标类型 1:自身 2:友方单人 3:友方小队, 4:敌方单人 5:敌方小队
    BOOL isSceneSkill; // 是否是释放到场景上的技能
    int skillWay; // 释放类型
    NSString *skillAction; // 技能动作标识类型
    int playerTimes; // 
}

@property (readonly,nonatomic) int skillId;

@property (readonly,nonatomic) NSString *name;

@property (readonly,nonatomic) int requiredLevel;

@property (readonly,nonatomic) int schoolId;

@property (readonly,nonatomic) int effectTarget;

@property (readonly,nonatomic) int skillArea;

@property (readonly,nonatomic) int continueTime;

@property (readonly,nonatomic) int happenFrequence;

@property (readonly,nonatomic) int coldTime;

@property (readonly,nonatomic) int coldGroup;

@property (readonly,nonatomic) int cost;

@property (readonly,nonatomic) int iconId;

@property (readonly,nonatomic) NSString *skillEffect1;

@property (readonly,nonatomic) int effectPosition1;

@property (readonly,nonatomic) NSString *skillEffect2;

@property (readonly,nonatomic) int effectPosition2;

@property (readonly,nonatomic) NSString *skillEffect3;

@property (readonly,nonatomic) int effectPosition3;

@property (readonly,nonatomic) int targetType;

@property (readonly,nonatomic) BOOL isSceneSkill;

@property (readonly,nonatomic) int skillWay;

@property (readonly,nonatomic) NSString *skillAction;

@property (readonly,nonatomic) int playerTimes;

/// 初始化
-(id) initWithConfig:(NSDictionary*)config;

@end
