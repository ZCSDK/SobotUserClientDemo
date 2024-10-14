import { SobotEmitterIdConstants } from '@sobot/chat_core';
import { SobotEmitterUtil } from '@sobot/sobot_common';
import { HomeTabContent } from './HomeTabContent';
import { SettingTabContent } from './SettingTabContent';

import SobotChatCore from '@sobot/chat_core/src/main/ets/chatapi/SobotChatCore';

@Entry
@Component
struct Index {
  @State fontColor: ResourceColor = $r('app.color.sobot_color_text_first');
  @State selectedFontColor: ResourceColor = $r('app.color.sobot_color_theme');
  @State currentIndex: number = 0;
  private controller: TabsController = new TabsController();
  @State unReadNum: number = 0;

  aboutToAppear(): void {
    // 监听未读消息
    SobotEmitterUtil.listenString(SobotEmitterIdConstants.RECEIVE_NEW_MESSAGE_PARSED, (data) => {
      if (data != null) {
        this.unReadNum = SobotChatCore.unreadNum;
      }
    });
  }

  @Builder
  tabBarBuilder(index: number, name: string, img: ResourceStr, num?: number) {
    Column() {
      RelativeContainer() {
        Column() {
          Image(img)
            .width(24)
            .height(24)
            .margin({ bottom: 4 })
            .objectFit(ImageFit.Contain)
          Text(name)
            .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
            .fontWeight(500)
            .lineHeight(20)
            .fontSize(14)
        }.width('100%').height('100%').justifyContent(FlexAlign.Center)

        if (num != undefined && num > 0) {
          Text("" + num)
            .backgroundColor(Color.Red)
            .borderRadius(10)
            .height(20)
            .constraintSize({
              minWidth: 20
            })
            .textAlign(TextAlign.Center)
            .fontSize(10)
            .fontColor(Color.White)
            .zIndex(1)
            .margin({ right: 20 })
            .alignRules({
              top: { anchor: "__container__", align: VerticalAlign.Top },
              right: { anchor: "__container__", align: HorizontalAlign.End }
            })
        }
      }.width('100%').height('100%')
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex, controller: this.controller }) {
        TabContent() {
          Column() {
            HomeTabContent()
          }.width('100%')
          .height('100%')
        }.tabBar(this.tabBarBuilder(0, '首页', $r("sys.media.ohos_ic_public_more"), this.unReadNum))

        TabContent() {
          Column() {
            SettingTabContent()
          }
          .width('100%')
          .height('100%')
          .backgroundColor($r('sys.color.brand'))
        }.tabBar(this.tabBarBuilder(1, '设置', $r("sys.media.ohos_ic_public_edit")))
      }
      .width('100%')
      .layoutWeight(1)
      .barWidth(360)
      .barHeight(56)
      .vertical(false)
      .barMode(BarMode.Fixed)
      .margin({ top: 0 })
      .animationDuration(0) // 设置动画时间为0，即可解决跨页切换显示中间过渡页面
      .onChange((index: number) => {
        this.currentIndex = index;
      })
    }.backgroundColor($r('app.color.sobot_color_bg_first'))
    .width('100%')
    .height('100%')
  }
}

