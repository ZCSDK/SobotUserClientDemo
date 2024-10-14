/**
 * 添加描述
 *
 * @author zhangxy
 * @since 2024−09-06
 *
 * Copyright sobot - 2024, All rights reserved.
 */
import { SobotStrUtil } from '@sobot/sobot_common'
import { DemoPropertiesModel } from '../tools/DemoPropertiesModel'
import DemoTools from '../tools/DemoTools'

@Preview
@Component
export struct SettingTabContent {
  private timetable: Array<Record<string, number | string | object>> = DemoTools.findAllSetting()

  @Builder
  itemHead(text: string) {
    Text(text)
      .fontSize(18)
      .backgroundColor(0xAABBCC)
      .width("100%")
      .padding(10)
  }

  @Builder
  itemFoot(api: string) {
    Text("" + api)
      .fontSize(16)
      .backgroundColor(0xAABBCC)
      .width("100%")
      .padding(5)
  }

  @Builder
  itemList(item: DemoPropertiesModel) {
    if (item.action == 1) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Text("" + item.desc + "")
          .fontSize(14)
          .textAlign(TextAlign.Start)
        Blank()
        Image($r("sys.media.ohos_ic_public_arrow_right")).width(20).height(20).fillColor(Color.Black)
          .margin({ right: 20 })
      }.alignSelf(ItemAlign.Stretch)
    } else if (item.action == 0) {
      Text("[说明：" + item.desc + "]")
        .fontSize(14).visibility(SobotStrUtil.isNotEmpty(item.desc) ? Visibility.Visible : Visibility.None)
        .padding(5)
      if (item.ptype == 0) {
        TextInput({ text: item.m_value as string })
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14 })
          .caretColor(Color.Blue)
          .height(40)
          .fontSize(14)
          .fontColor(Color.Black)
          .border({
            width: 1, style: BorderStyle.Solid, color: Color.Gray
          })// .inputFilter('[a-z]', (e) => {
            //   console.log(JSON.stringify(e))
            // })
          .onChange((value: string) => {
            item.m_value = value
          })
          .flexBasis('auto')
      } else if (item.ptype == 1) {
        TextArea({ text: item.m_value as string, placeholder: item.desc })
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14 })
          .caretColor(Color.Blue)
          .height(60)
          .fontSize(14)
          .flexBasis('auto')
          .fontColor(Color.Black)
          .border({
            width: 1, style: BorderStyle.Solid, color: Color.Gray
          })// .inputFilter('[a-z]', (e) => {
            //   console.log(JSON.stringify(e))
            // })
          .onChange((value: string) => {
            item.m_value = value.trim()
          })
      } else if (item.ptype == 2) {
        Toggle({ type: ToggleType.Switch, isOn: item.m_value as boolean })
          .selectedColor('#007DFF')
          .switchPointColor('#FFFFFF')
          .onChange((isOn: boolean) => {
            item.m_value = isOn
            console.info('Component status:' + isOn)
          })
      }
    }
  }

  getSubs(item: Record<string, number | string | object>) {
    let sub = item["subItem"] as Array<DemoPropertiesModel>;
    return sub;
  }

  getFooterCount(item: Record<string, number | string | object>): string {
    let sub = item["subItem"] as Array<DemoPropertiesModel>;
    return "详细说明：" + item["api"] + "" + sub.length + "个";
  }

  build() {
    Column() {
      Stack() {
        Text('功能说明').fontSize(20).fontColor($r('app.color.sobot_color_text_first')).width('100%')
          .textAlign(TextAlign.Center)

        Text('保存')
          .fontSize(16)
          .fontColor($r('app.color.sobot_color_theme'))
          .width('100%')
          .padding({
            top: 8,
            bottom: 8,
            left: 24,
            right: 24
          })
          .textAlign(TextAlign.End)
          .onClick(() => {
            DemoTools.saveAllValues()
          })
      }

      Line()
        .strokeWidth(1)
        .backgroundColor($r('app.color.sobot_color_line_bg'))
        .height(1)
        .margin({ top: $r('app.float.sobot_vp_chatmsg_border_padding') })
        .width('100%')
        .margin({ top: 10 })

      List({ space: 20 }) {
        ForEach(this.timetable, (item: Record<string, number | string | object>, index) => {
          ListItemGroup({
            header: this.itemHead(item["title"] as string),
            // footer: this.itemFoot(this.getFooterCount(item))
          }) {
            ForEach(this.getSubs(item), (model: DemoPropertiesModel, _index) => {
              ListItem() {
                Flex({ direction: FlexDirection.Column }) {
                  Text(model.title)
                    .fontSize(16)
                  Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
                    this.itemList(model);
                  }
                  .padding({
                    top: 6
                  })
                }.padding(6).onClick(() => {
                  DemoTools.itemClick(model)
                })
              }
            })
          }
          .borderRadius(5)
          .divider({ strokeWidth: 1, color: Color.Blue }) // 每行之间的分界线
        })
      }
      .width('100%').padding(16).margin({bottom:40})
      .sticky(StickyStyle.Header | StickyStyle.Footer)
    }.width('100%').height('100%').backgroundColor($r('app.color.sobot_color_bg_first')).padding({ top: 5 })
  }
}