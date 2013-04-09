


// 表现层标签
typedef enum _LayerTags
{
    kTagStonePanelEffectLayer, // 效果表现层
    kTagHudLayer,
    kTagFadeLayer,
    kTagObjectPlaceButtonsBar
}LayerTags;

typedef enum _FightLayerTags
{
    kTagLeftStonePanel = 10, // 左侧面板Tag
    kTagRightStonePanel, // 右侧面板Tag
    kTagFighterUI, // 战士UI
    kTagTopUI, // 顶层UI
    kTagBottomUI // 底部UI
}FightLayerTags;


// 技能类型
#define kSkillTypeNormal 1 // 普通类型
#define kSkillTypeEx1 2 // ex1 技能
#define kSkillTypeEx2 // ex2 技能
#define kSkillTypeEx3 // ex3 技能

// 宝石状态
#define kStoneStateIdle 0 // 闲置
#define kStoneStateDisposing 1 // 正在消除
#define kStoneStateDisposed 2 // 已经消除 (可以从屏幕上移除了)

// 特殊宝石
#define kStoneSpecialExplode 4 // 爆
#define kStoneSpecialFire 5 // 火
#define kStoneSpecialLight 6 // 闪电
#define kStoneSpecialBlack 7 // 黑洞

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
#define SERVER_TYPE_GAME @"game" // 战斗服务器
#define SERVER_TYPE_LOGIN @"login" // 登录服务器
#define SERVER_TYPE_CHAT @"chat" // 聊天服务器

// 服务器动作标识
#define SERVER_ACTION_ID_PLAYER_INFO 1 // 玩家信息
#define SERVER_ACTION_ID_UPDATE_HERO 20 // 更新英雄信息
#define SERVER_ACTION_ID_STONE_COLUMN 2 //  宝石队列信息
#define SERVER_ACTION_ID_SWAP_STONES 7 // 交换宝石
#define SERVER_ACTION_ID_ADD_NEW_STONES 8 // 增加新的宝石
#define SERVER_ACTION_ID_DEAD_STONE_COLUMN 9 // 死局获得新的宝石队列
#define SERVER_ACTION_ID_CHANGE_INFO 10 // 怒气和血条的改变
#define SERVER_ACTION_ID_ATTACK 12 // 服务器端返回的攻击数据
#define SERVER_ACTION_ID_ALL_SKILL_INFO 14 // 所有技能信息
#define SERVER_ACTION_ID_HOME_CONNECT 15 // 连接房间
#define SERVER_ACTION_ID_QUIT_FIGHT 16 // 退出战斗
#define SERVER_ACTION_ID_UPDATE_PLAYER_INFO 21 // 更新玩家信息

// PVP Fight
#define SERVER_ACTION_ID_PVP_OPPONENT_AND_FIGHTERS 800 // PVP战场对手及所有英雄战士信息列表
#define SERVER_ACTION_ID_PVP_START_ENABLE 801 // 是否可以开始游戏,开始按钮高亮
#define SERVER_ACTION_ID_PVP_START_FIGHT 802 // 开始战斗,进行战斗初始化操作


#define SERVER_ACTION_ID_ERROR_MESSAGE 1000 // 错误信息

#ifdef __XPLAN__

#define kTaskState 0 // 任务状态



#endif
