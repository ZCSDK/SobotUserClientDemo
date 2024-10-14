/**
 * 属性模型
 *
 * @author zhangxy
 * @since 2024−09-06
 *
 * Copyright sobot - 2024, All rights reserved.
 */

@ObservedV2
export class DemoPropertiesModel {
  code:string = "0";

  // 当前的下标
  index:number = -1;

  // 父类的index
  pIndex:number = -1;

  // 显示的标题和描述
  title:string="";
  desc:string ="";

  // 属性key，与SobotChatParameter对应
  m_key:string ="";

  @Trace
  // 属性值
  m_value:string|boolean|number = "";

  // 帮助文档说明
  api:string = "";

  // 0 属性，1事件
  action:number = 0;

  // 事件 类型
  eventType:number = 0;

  // 0文本，1，多行输入，2单选
  ptype:number = 0;


}