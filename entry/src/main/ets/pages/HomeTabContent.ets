/**
 * 添加描述
 *
 * @author zhangxy
 * @since 2024−09-06
 *
 * Copyright sobot - 2024, All rights reserved.
 */
import { BusinessError } from '@kit.BasicServicesKit';
import SobotChatClient, {
    SobotEventSource,
    SobotEventType
} from '@sobot/chat_core/src/main/ets/chatapi/SobotChatClient';
import { SobotStrUtil, SobotToastUtil } from '@sobot/sobot_common';

import DemoTools from '../tools/DemoTools';
import { ZCSobotApi } from '@sobot/chat_client';

@Component
export struct HomeTabContent {
  build() {
    Column() {
      Text('启动客户服务中心')
        .fontSize(18)
        .backgroundColor($r('app.color.sobot_color_msg_left_bg'))
        .fontColor($r('app.color.sobot_color_text_first'))
        .padding(10)
        .textAlign(TextAlign.Center)
        .borderRadius(8)
        .margin({ top: 20 })
        .onClick(() => { // 点击跳转到其他共享包中的页面
          try {
            if (SobotStrUtil.isEmpty(DemoTools.getChatParameter().app_key)) {
              SobotToastUtil.showShort("appkey 不能为空，请到设置界面设置相关配置信息")
              return
            }
            ZCSobotApi.openZCServiceCenter(DemoTools.getChatParameter());
          } catch (err) {
            let message = (err as BusinessError).message
            let code = (err as BusinessError).code
            console.error(`pushNamedRoute failed, code is ${code}, message is ${message}`);
          }
        })
        .width(200)

      Text('启动聊天')
        .fontSize(18)
        .backgroundColor($r('app.color.sobot_color_msg_left_bg'))
        .fontColor($r('app.color.sobot_color_text_first'))
        .padding(10)
        .textAlign(TextAlign.Center)
        .borderRadius(8)
        .margin({ top: 20 })
        .onClick(() => { // 点击跳转到其他共享包中的页面
          try {
            SobotChatClient.addLinkEventCallBack((from: SobotEventSource, eventType: SobotEventType,
              linkStr: string): boolean => {
              if (eventType == SobotEventType.EventTypeLocaLocation) {
                if (SobotStrUtil.isNotEmpty(linkStr) && linkStr.search("item.jd.com")) {
                  SobotToastUtil.showShort("拦截超链接：" + linkStr);
                  return true;
                }
              }
              if (eventType == SobotEventType.EventTypeLocaLocation) {
                SobotToastUtil.showShort("拦截位置：" + SobotStrUtil.checkStringIsNull(linkStr));
                return true;
              }
              return false;
            });
            if (SobotStrUtil.isEmpty(DemoTools.getChatParameter().app_key)) {
              SobotToastUtil.showShort("appkey 不能为空，请到设置界面设置相关配置信息")
              return
            }
            ZCSobotApi.openZCChat(DemoTools.getChatParameter());
          } catch (err) {
            let message = (err as BusinessError).message
            let code = (err as BusinessError).code
            console.error(`pushNamedRoute failed, code is ${code}, message is ${message}`);
          }
        })
        .width(200)

    }.backgroundColor($r('app.color.sobot_color_bg_first'))
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}