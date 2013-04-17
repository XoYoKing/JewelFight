

/// 游戏状态
typedef enum _GameStates
{
    kGameStateLoading = 0, // 加载状态
    kGameStateHome = 1, // Home状态
    kGameStatePvP = 2 // PvP状态
}GameStates;

// 表现层标签
typedef enum _LayerTags
{
    kTagHudLayer = 100,
    kTagFadeLayer,
    kTagEffectLayer,
    kTagObjectPlaceButtonsBar
}LayerTags;

typedef enum _FightLayerTags
{
    kTagLeftJewelPanel = 10, // 左侧面板Tag
    kTagRightJewelPanel, // 右侧面板Tag
    kTagFighterUI, // 战士UI
    kTagTopUI, // 顶层UI
    kTagBottomUI // 底部UI
}FightLayerTags;


#define kTagPvPLoadingLayer 100 // pvp加载层
#define kTagPvPLayer 101 // pvp战斗层
#define kTagPvPHudLayer 102 // pvp Hud层

// 技能类型
#define kSkillTypeNormal 1 // 普通类型
#define kSkillTypeEx1 2 // ex1 技能
#define kSkillTypeEx2 // ex2 技能
#define kSkillTypeEx3 // ex3 技能

// 宝石格子数
#define kJewelGridWidth 5 // 宝石格子宽数量
#define kJewelGridHeight 7 // 宝石格子高数量

#define kJewelCellSizeWidth 41
#define kJewelCellSizeHeight 41

#define kJewelEliminateMinNeed 3 // 消除宝石最少需要的数量

// 宝石类型
#define kJewelTypeNormal 1 // 普通宝石
#define kJewelTypeSpecial 2 // 特殊宝石

// 宝石状态
#define kJewelStateDropping 0 // 下落中
#define kJewelStateIdle 1 // 正常
#define kJewelStateFiring 2 // 正在燃烧
#define kJewelStateLighting 3 // 正在闪电
#define kJewelStateSelected 4 // 被选中
#define kJewelStateDragging 5 // 拖放中
#define kJewelStateEliminating 6 // 正在消除
#define kJewelStateEliminated 7 // 已经消除 (可以从屏幕上移除了)

// 特殊宝石
#define kJewelSpecialExplode 4 // 爆
#define kJewelSpecialFire 5 // 火
#define kJewelSpecialLight 6 // 闪电
#define kJewelSpecialBlack 7 // 黑洞

// 宝石效果
#define kJewelEffectSelected @"selected" // 宝石选中
#define kJewelEffectEliminate @"eliminate" // 普通消除
#define kJewelEffectFire @"fire" // 燃烧效果
#define kJewelEffectFireElimate @"fireElimate" // 燃烧消失效果
#define kJewelEffectLight @"light" // 闪电效果
#define kJewelEffectLightElimate @"lightElimate" // 闪电消失效果
#define kJewelEffectBlack @"black" // 黑洞效果
#define kJewelEffectBlackElimate @"blackElimate" // 黑洞消失效果
#define kJewelEffectExplode @"explode" // 爆炸效果
#define kJewelEffectExplodeElimate @"explodeElimate" // 爆炸消失效果


// 聊天
#define kChatChannelGlobal 0 // 聊天频道: 综合
#define kChatChannelNormal 1 // 聊天频道: 当前
#define kChatChannelPrivate 2 // 聊天频道: 私聊
#define kChatChannelFamily 3 // 聊天频道: 公会
#define kChatChannelTeam 4 // 聊天频道: 队伍
#define kChatChannelWorld 5 // 聊天频道: 世界
#define kChatChannelRoom 6 // 聊天频道: 房间
#define kChatChannelFight 7 // 聊天频道: 战斗
#define kChatChannelHorn 8 // 聊天频道: 喇叭
#define kChatChannelSystem 9 // 聊天频道: 系统
#define kChatChannelChuanYin 10 // 聊天频道: 传音

// 服务器类别
#define SERVER_GAME @"game" // 游戏主服务器
#define SERVER_PVP @"pvp" // pvp服务器
#define SERVER_LOGIN @"login" // 登录服务器
#define SERVER_CHAT @"chat" // 聊天服务器

// 向服务器请求动作标识
#define CLIENT_ACTION_PVP_REQUEST_PVP 1 // 请求pvp

// 服务器响应动作标识
#define SERVER_ACTION_PLAYER_INFO 1 // 玩家信息
#define SERVER_ACTION_UPDATE_HERO 20 // 更新英雄信息

#define SERVER_ACTION_ALL_SKILL_INFO 14 // 所有技能信息
#define SERVER_ACTION_HOME_CONNECT 15 // 连接房间
#define SERVER_ACTION_QUIT_FIGHT 16 // 退出战斗
#define SERVER_ACTION_UPDATE_PLAYER_INFO 21 // 更新玩家信息

// PVP Fight start from 800
#define SERVER_ACTION_PVP_OPPONENT_AND_FIGHTERS 800 // PVP战场对手及所有英雄战士信息列表
#define SERVER_ACTION_PVP_INIT_STONES 801 //  初始化宝石队列信息
#define SERVER_ACTION_PVP_FIGHT_START 802 // 开始战斗,进行战斗初始化操作
#define SERVER_ACTION_PVP_SWAP_STONES 7 // 交换宝石
#define SERVER_ACTION_PVP_ADD_NEW_STONES 8 // 增加新的宝石
#define SERVER_ACTION_PVP_DEAD_STONE_COLUMN 9 // 死局获得新的宝石队列
#define SERVER_ACTION_PVP_CHANGE_INFO 10 // 怒气和血条的改变
#define SERVER_ACTION_PVP_ATTACK 12 // 服务器端返回的攻击数据



#define SERVER_ACTION_ERROR_MESSAGE 1000 // 错误信息


#ifdef __XPLAN__

#define kTaskState 0 // 任务状态



#endif
