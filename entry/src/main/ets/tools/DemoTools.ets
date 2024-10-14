/**
 * 调用demo管理类
 *
 * @author zhangxy
 * @since 2024−09-06
 *
 * Copyright sobot - 2024, All rights reserved.
 */
import { DemoValueTools } from './DemoValueTools';
import { JSON } from '@kit.ArkTS';
import { DemoPropertiesModel } from './DemoPropertiesModel';
import { SobotChatParameter, ZCSobotApi } from '@sobot/chat_client';
import { SobotStrUtil, SobotToastUtil } from '@sobot/sobot_common';
import preferenceUtil from './PreferencesUtil';

declare type SobotDemoSetting = string | number | boolean | object | null | undefined;

class DemoTools {
  private chatParameter = new SobotChatParameter();
  private allSettings: Array<Record<string, number | string | object>> = new Array();

  constructor() {
    preferenceUtil.initPreferences()
    let tempStr = preferenceUtil.getString("demo_chatParameter")
    let tempModel: SobotChatParameter | null = null
    if (SobotStrUtil.isNotEmpty(tempStr)) {
      tempModel = JSON.parse(tempStr) as SobotChatParameter
    }
    if (tempModel != null) {
      this.chatParameter = tempModel;
    } else {
      // 设置默认值
      DemoValueTools.configInitParameter(this.chatParameter);
    }
    this.configSetting();
  }

  public getChatParameter() {
    return this.chatParameter;
  }

  public getAllParameterKeys(): Array<string> {
    let jsonItems = JSON.stringify(this.chatParameter);
    let items: Record<string, SobotDemoSetting> = JSON.parse(jsonItems) as Record<string, SobotDemoSetting>;
    return Object.keys(items)
  }

  // 查询所有内容
  public findAllSetting() {
    return this.allSettings;
  }

  /**
   * 把当前的属性值保存到初始化对象中
   * @param item
   */
  public saveValueToParameter(item: DemoPropertiesModel) {
    if (item.m_key.length > 0 && item.action == 0) {
      let jsonItems = JSON.stringify(this.chatParameter);
      let items: Record<string, SobotDemoSetting> = JSON.parse(jsonItems) as Record<string, SobotDemoSetting>;
      items[item.m_key] = item.m_value;
      this.chatParameter = JSON.parse(JSON.stringify(items)) as SobotChatParameter;
      preferenceUtil.set("demo_chatParameter", JSON.stringify(this.chatParameter))
    }
  }

  /**
   * 保存所有编辑数据
   */
  public saveAllValues() {
    let jsonItems = JSON.stringify(this.chatParameter);
    let items: Record<string, SobotDemoSetting> = JSON.parse(jsonItems) as Record<string, SobotDemoSetting>;

    for (let i = 0; i < this.allSettings.length; i++) {
      let p = this.allSettings[i];
      let subItems = p["subItem"] as Array<DemoPropertiesModel>;
      for (let j = 0; j < subItems.length; j++) {
        let m = subItems[j];
        if (m.m_key.length > 0 && m.action == 0) {
          items[m.m_key] = m.m_value;
        }
      }
    }

    let json = JSON.stringify(items);
    console.log("格式化的内容", json)
    this.chatParameter = JSON.parse(json) as SobotChatParameter;
    preferenceUtil.set("demo_chatParameter", json)
    if (SobotStrUtil.isEmpty(this.chatParameter.app_key)) {
      SobotToastUtil.showShort("appkey 不能为空，请到设置界面设置相关配置信息")
    } else {
      SobotToastUtil.showShort('保存成功')
    }
  }

  public itemClick(item: DemoPropertiesModel) {
    if (this.chatParameter != null) {
      if (SobotStrUtil.isEmpty(this.chatParameter.app_key)) {
        SobotToastUtil.showShort("appkey 不能为空，请到设置界面设置相关配置信息")
        return
      }
      if (item.action == 1) {
        // 点击事件
        if (item.eventType == 0) {
        } else if (item.eventType == 1) {
          ZCSobotApi.openZCChat(this.getChatParameter())
        } else if (item.eventType == 2) {
          ZCSobotApi.openZCServiceCenter(this.getChatParameter())
        } else if (item.eventType == 3) {
          ZCSobotApi.outCurrentUserZCLibInfo()
        }
      }
    }
  }

  /**
   * 配置当前功能菜单
   */
  public configSetting() {
    this.allSettings.push({
      "index": 0,
      "code": "0",
      "title": "基础设置",
      "desc": "说明",
      "api": "地址",
      "subItem": [
        this.revertModel({
          "index": 0,
          "code": "0",
          "pIndex": 0,
          "title": "设置域名",
          "desc": "不设置默认为阿里云环境：https://www.sobot.com,可以修改成腾讯云环境：https://www.soboten.com,其它根据自己服务环境配置域名",
          "api": "地址",
          "m_key": "api_host",
          "m_value": this.chatParameter.api_host,
          "action": 0,
          "ptype": 0
        }),
        this.revertModel({
          "index": 1,
          "code": "1",
          "pIndex": 0,
          "title": "设置app_key",
          "desc": "渠道唯一标识，必须配置",
          "api": "地址",
          "m_key": "app_key",
          "m_value": this.chatParameter.app_key,
          "action": 0,
          "ptype": 0
        }),
        this.revertModel({
          "index": 2,
          "code": "2",
          "pIndex": 0,
          "title": "设置partnerid",
          "desc": "用户身份唯一标识,建议传入，如果为空会默认生成一个临时标识",
          "api": "地址",
          "m_key": "partnerid",
          "m_value": this.chatParameter.partnerid,
          "action": 0,
          "ptype": 0
        }),
      ]
    })

    this.allSettings.push({
      "index": 1,
      "code": "1",
      "title": "常用功能",
      "desc": "说明",
      "api": "地址",
      "subItem": [
        this.revertModel({
          "index": 1,
          "code": "1",
          "pIndex": 1,
          "title": "启动客服",
          "desc": "初始化有效后才能启动",
          "api": "地址",
          "action": 1,
          "eventType": 1
        }),
        this.revertModel({
          "index": 2,
          "code": "2",
          "pIndex": 1,
          "title": "启动客户服务中心",
          "desc": "发起咨询前，可根据问题分类或服务热线，快速解决问题",
          "api": "地址",
          "action": 1,
          "eventType": 2
        }),
        this.revertModel({
          "index": 3,
          "code": "3",
          "pIndex": 1,
          "title": "结束会话",
          "desc": "调用此方法后，用户离线，不会再收到客服消息",
          "api": "地址",
          "action": 1,
          "eventType": 3
        }),
      ]
    })

    this.allSettings.push({
      "index": 2,
      "code": "2",
      "title": "接待相关设置",
      "desc": "指定接待模式、指定客服、指定技能组...",
      "api": "地址",
      "subItem": [
        this.revertModel({
          "index": 0,
          "code": "0",
          "pIndex": 2,
          "title": "设置接待模式",
          "desc": "默认跟随服务端配置，如果本地配置,本地优先;默认-1不指定；1仅机器人;2仅人工;3机器人优先;4人工优先",
          "api": "地址",
          "m_key": "service_mode",
          "m_value": this.chatParameter.service_mode,
          "action": 0,
          "ptype": 0
        }), this.revertModel({
        "index": 1,
        "code": "1",
        "pIndex": 2,
        "title": "客服ID",
        "desc": "指定客服ID,指定后，由该客服接待",
        "api": "地址",
        "m_key": "group_id",
        "m_value": this.chatParameter.group_id,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 2,
        "code": "2",
        "pIndex": 2,
        "title": "指定客服时转接类型",
        "desc": "0 可转入其他客服 ，1 必须转入指定客服（注意：如果当前指定的客服不在线，选择之后不能在转接到其他客服）",
        "api": "地址",
        "m_key": "tran_flag",
        "m_value": this.chatParameter.tran_flag,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 3,
        "code": "3",
        "pIndex": 2,
        "title": "技能组ID",
        "desc": "指定技能组ID,指定后，转人工不会再弹技能组选项",
        "api": "地址",
        "m_key": "group_id",
        "m_value": this.chatParameter.group_id,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 4,
        "code": "4",
        "pIndex": 2,
        "title": "技能组名称",
        "desc": "指定技能组名称",
        "api": "地址",
        "m_key": "group_name",
        "m_value": this.chatParameter.group_name,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 5,
        "code": "5",
        "pIndex": 2,
        "title": "指定客户排队优先接入",
        "desc": " 1:优先接入  0:默认值，正常排队",
        "api": "地址",
        "m_key": "queueFirst",
        "m_value": this.chatParameter.queue_first,
        "action": 0,
        "ptype": 0
      })]
    })

    this.allSettings.push({
      "index": 3,
      "code": "3",
      "title": "UI相关设置",
      "desc": "说明",
      "api": "地址",
      "subItem": [

        this.revertModel({
          "index": 0,
          "code": "0",
          "pIndex": 3,
          "title": "指定国际化语言",
          "desc": "指定语言编码，例如：zh-Hans：简体中文、en：英文，其他语言编码参考《客户SDK支持语言编码表》",
          "api": "地址",
          "m_key": "locale",
          "m_value": this.chatParameter.locale,
          "action": 0,
          "ptype": 0
        }),
        this.revertModel({
          "index": 1,
          "code": "1",
          "pIndex": 3,
          "title": "左上角返回时是否弹出(您是否结束会话？)",
          "desc": "true:弹出，false:不弹,默认false",
          "api": "地址",
          "m_key": "isShowLeftBackPop",
          "m_value": this.chatParameter.isShowLeftBackPop,
          "action": 0,
          "ptype": 2
        }),
        this.revertModel({
          "index": 2,
          "code": "2",
          "pIndex": 3,
          "title": "是否显示关闭结束会话按钮",
          "desc": "true:显示，false:不显示,默认false",
          "api": "地址",
          "m_key": "isShowCloseButton",
          "m_value": this.chatParameter.isShowCloseButton,
          "action": 0,
          "ptype": 2
        }), this.revertModel({
        "index": 3,
        "code": "3",
        "pIndex": 3,
        "title": "是否显示暂不评价按钮",
        "desc": "左上角返回和右上角关闭 返回弹出评价窗口时，是否显示暂不评价按钮，弹窗中暂不评价按钮和关闭只能显示一个，true:显示，false:不显示,默认false",
        "api": "地址",
        "m_key": "canBackWithNotEvaluation",
        "m_value": this.chatParameter.canBackWithNotEvaluation,
        "action": 0,
        "ptype": 2
      })
      ]
    })

    this.allSettings.push({
      "index": 4,
      "code": "4",
      "title": "其它设置",
      "desc": "说明",
      "api": "地址",
      "subItem": [

        this.revertModel({
          "index": 0,
          "code": "0",
          "pIndex": 4,
          "title": "自定义聊天记录显示时间范围",
          "desc": "最多只能显示60天内的消息,单位(分钟),不传默认是0,会显示所有的历史记录，(例:100-表示从现在起前100分钟的会话)",
          "api": "地址",
          "m_key": "scope_time",
          "m_value": this.chatParameter.scope_time,
          "action": 0,
          "ptype": 0
        }),
        this.revertModel({
          "index": 1,
          "code": "1",
          "pIndex": 4,
          "title": "公司名称",
          "desc": "",
          "api": "地址",
          "m_key": "enterprise_name",
          "m_value": this.chatParameter.enterprise_name,
          "action": 0,
          "ptype": 0
        }),
        this.revertModel({
          "index": 2,
          "code": "2",
          "pIndex": 4,
          "title": "消息提醒通知",
          "desc": "不再聊天页收到客服消息时，通知栏是否显示该消息，默认不显示，app退到后台会收不到消息，这是系统机制导致的，需要使用华为推送，可在后台渠道里边配置",
          "api": "地址",
          "m_key": "msgNotificationFlag",
          "m_value": this.chatParameter.msgNotificationFlag,
          "action": 0,
          "ptype": 2
        })
      ]
    })

    this.allSettings.push({
      "index": 5,
      "code": "5",
      "title": "用户信息",
      "desc": "选填",
      "api": "地址",
      "subItem": [
        this.revertModel({
          "index": 0,
          "code": "0",
          "pIndex": 5,
          "title": "设置用户昵称",
          "desc": "客服工作台显示进线用户的昵称",
          "api": "地址",
          "m_key": "user_nick",
          "m_value": this.chatParameter.user_nick,
          "action": 0,
          "ptype": 0
        }),
        this.revertModel({
          "index": 1,
          "code": "1",
          "pIndex": 5,
          "title": "设置用户姓名",
          "desc": "客服工作台显示进线用户的姓名",
          "api": "地址",
          "m_key": "user_name",
          "m_value": this.chatParameter.user_name,
          "action": 0,
          "ptype": 0
        }),
        this.revertModel({
          "index": 2,
          "code": "2",
          "pIndex": 5,
          "title": "设置用户头像",
          "desc": "客服工作台显示进线用户的头像",
          "api": "地址",
          "m_key": "face",
          "m_value": this.chatParameter.face,
          "action": 0,
          "ptype": 0
        }), this.revertModel({
        "index": 3,
        "code": "3",
        "pIndex": 5,
        "title": "设置用户邮箱",
        "desc": "客服工作台显示进线用户的邮箱",
        "api": "地址",
        "m_key": "user_emails",
        "m_value": this.chatParameter.user_emails,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 4,
        "code": "4",
        "pIndex": 5,
        "title": "设置用户电话",
        "desc": "客服工作台显示进线用户的电话",
        "api": "地址",
        "m_key": "user_tels",
        "m_value": this.chatParameter.user_tels,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 4,
        "code": "4",
        "pIndex": 5,
        "title": "备注",
        "desc": "",
        "api": "地址",
        "m_key": "remark",
        "m_value": this.chatParameter.remark,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 5,
        "code": "5",
        "pIndex": 5,
        "title": "指定客户是否为vip",
        "desc": "0:普通 1:vip,  开启传1 默认不设置，PC端 设置-在线客服分配-排队优先设置-VIP客户排队优先，开启后 指定客户发起咨询时，如果出现排队，系统将优先接入。",
        "api": "地址",
        "m_key": "is_vip",
        "m_value": this.chatParameter.is_vip,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 6,
        "code": "6",
        "pIndex": 5,
        "title": "vip等级",
        "desc": "",
        "api": "地址",
        "m_key": "vip_level",
        "m_value": this.chatParameter.vip_level,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 7,
        "code": "7",
        "pIndex": 5,
        "title": "用户标签",
        "desc": "多个字段用逗号分隔",
        "api": "地址",
        "m_key": "user_label",
        "m_value": this.chatParameter.user_label,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 8,
        "code": "8",
        "pIndex": 5,
        "title": "用户自定义字段",
        "desc": "json格式字符串",
        "api": "地址",
        "m_key": "customer_fields",
        "m_value": this.chatParameter.customer_fields,
        "action": 0,
        "ptype": 0
      }), this.revertModel({
        "index": 9,
        "code": "9",
        "pIndex": 5,
        "title": "自定义用户资料",
        "desc": "json格式字符串",
        "api": "地址",
        "m_key": "params",
        "m_value": this.chatParameter.params,
        "action": 0,
        "ptype": 0
      })
      ]
    })
  }

  /**
   * 把Record转换成对象
   * @param item1
   * @returns
   */
  public revertModel(item: Record<string, string | number | boolean>): DemoPropertiesModel {
    let m: DemoPropertiesModel = new DemoPropertiesModel()
    m.index = item["index"] as number;
    m.code = item["code"] as string;
    m.pIndex = item["pIndex"] as number;
    m.title = item["title"] as string;
    m.desc = item["desc"] != undefined ? item["desc"] as string : "";
    m.api = item["api"] != undefined ? item["api"] as string : "";
    m.m_key = item["m_key"] != undefined ? item["m_key"] as string : "";
    m.m_value = item["m_value"] != undefined ? item["m_value"] as string : "";
    m.action = item["action"] as number;
    m.ptype = item["ptype"] as number;
    m.eventType = item["eventType"] as number;
    return m;
  }
}


export default new DemoTools();

