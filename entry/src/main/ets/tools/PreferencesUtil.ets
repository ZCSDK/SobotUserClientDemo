import dataPreferences from '@ohos.data.preferences';
import { BusinessError } from '@kit.BasicServicesKit';
import { SobotLogUtil, SobotStrUtil } from '@sobot/sobot_common';

/**
 * @desciption Preferences首选项工具类
 */

// 获取context
let context = getContext(this);

export class PreferencesUtil {
  preferences?: dataPreferences.Preferences;
  preferencesName: string = "SOBOT_CLIENT_DEMO_SDK";

  // 初始化preferences实例
  initPreferences() {
    try {
      this.preferences = dataPreferences.getPreferencesSync(context, { name: this.preferencesName });
    } catch (err) {
      let message = (err as BusinessError).message
      let code = (err as BusinessError).code
      SobotLogUtil.error(`PreferencesUtil failed, code is ${code}, message is ${message}`)
    }
  }

  // 设置数据
  set(key: string, value: dataPreferences.ValueType) {
    if (!this.preferences) {
      this.initPreferences();
    }
    SobotLogUtil.info(JSON.stringify(value).length + "------------------------")
    this.preferences?.putSync(key, value);
    this.preferences?.flush();
  }

  // 获取数据
  get(key: string): dataPreferences.ValueType | null | undefined {
    if (!this.preferences) {
      this.initPreferences();
    }
    let value = this.preferences?.getSync(key, null);
    return value;
  }

  /**
   * 获取string类型的缓存值
   * @param key
   * @returns
   */
  getString(key: string): string {
    return SobotStrUtil.checkStringIsNull(this.get(key) as string);
  }

  /**
   * 获取number类型的缓存值
   * @param key
   * @returns
   */
  getNumber(key: string): number {
    return this.get(key) as number;
  }

  /**
   * 获取boolean类型的缓存值
   * @param key
   * @returns
   */
  getBoolean(key: string): boolean {
    return this.get(key) as boolean;
  }

  /**
   * 检查缓存的Preferences实例中是否包含名为给定Key的存储键值对
   * @param key
   * @param preferenceName
   * @returns
   */
  has(key: string): boolean {
    if (!this.preferences) {
      this.initPreferences();
    }
    if (this.preferences?.hasSync(key)) {
      return true;
    } else {
      return false;
    }
  }

  // 删除数据
  delete(key: string) {
    if (!this.preferences) {
      this.initPreferences();
    }
    if (this.preferences?.hasSync(key)) {
      this.preferences.deleteSync(key);
      this.preferences.flush();
    }
  }
}

const preferenceUtil = new PreferencesUtil()

export default preferenceUtil

