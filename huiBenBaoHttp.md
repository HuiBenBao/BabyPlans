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
		"code": "200",							// 请求结果状态码
		"data": {
			"code": "374892"					// 验证码
		},
		"error": ""
	}

