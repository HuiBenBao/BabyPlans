# 绘本宝

###接口列表

1. 用户接口

	1.1 <a href="#1.1">获取广场数据</a>	POST action: gallery_query<br/>



###<a name="1.1">1.1 获取广场数据</a>

######请求接口
POST action = gallery_query

######请求参数
	{
	"page": "",				// 页
        "type":"0"                              // 0：原创 1：经典
        "count":"5"			//条数
	}
	
######返回值
	{
		"status" : 0,
 	 	"action" : "GalleryQuery",
 		 "galleries" : [{
		      "id" : 1224,			作品
		      "commentLength" : 0,   评论
		      "introLength" : 8,	导语
		      "likeCnt" : 3,          点赞
		      "age" : 0,              年龄
		      "pictureCnt" : 13,  图片
		
				 "user" : {	     用户信息
				        "gender" : false,      性别   0男 1女
				        "id" : 497,            用户id
				        "atSchool" : false,        学校 
				        "commentMessage" : 1,      评论信息
				        "a" : false,           不知道干啥的
				        "isTeacher" : false,       老师
				        "name" : "竹马",            作者姓名
				        "fanCnt" : 1,               粉丝
				        "systemMessage" : 0,      系统消息
				        "createTime" : 1458279, 作品上传时间毫秒数
				        "del" : false,                  信箱
				        "friendCnt" : 0,     关注
				        "aMessage" :  0,     留言
				        "galleryCnt" : 2,         作品
				        "cityId" : 0,           城市
				        "friendMessage" : 0,         好友信息
				        "activityMessage" : 0        活动信息
				   },
			      "commentatorId" : 0,      
			      "priority" : 0,             优先级
			      "type" : 0,			类型        
			      "userId" : 497,			用户id
			      "createTime" : 1458282093000,
			      "del" : false,            
			      "cover" : 			作品合集封面图片
			      "introVoice" :,作品合集封面声音
			      "commentCnt" : 1,       评论
			      "cityId" : 0,			城市
			      "galleryBase" : ,  声音
	}

