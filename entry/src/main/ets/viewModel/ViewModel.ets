// Basic implementation of IDataSource to handle data listener
export class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): T {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

export class Model {
  text: string = ''

  constructor(text: string) {
    this.text = text;
  }
}

@Observed
export class ViewModel extends BasicDataSource<Model> {
  clickItem?: (index: number) => void
  itemColor: ResourceColor = '#95efd2'
  hasMoreData: boolean = true
  dataArray: Model[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): Model {
    return this.dataArray[index];
  }

  onRefreshing(finished?: () => void) {
    setTimeout(() => {
      if (this.itemColor == '#95efd2') {
        this.itemColor = '#abff57'
      } else {
        this.itemColor = '#95efd2'
      }
      if (this.totalCount() > 4) {
        let newDataArray: Model[] = []
        for (let index = 0; index < 4; index++) {
          newDataArray.push(this.getData(index))
        }
        this.dataArray = newDataArray
        this.notifyDataReload()
      }
      this.hasMoreData = true
      if (finished) {
        finished()
      }
    }, 1000)
  }

  onLoadMore(finished?: (hasMoreData: boolean) => void) {
    setTimeout(() => {
      const maxCount = 64
      if (this.totalCount() <= maxCount) {
        for (let index = 0; index < 20; index++) {
          this.pushData(new Model(`额外加载数据 ${this.totalCount()}`))
        }
      }
      this.hasMoreData = this.totalCount() <= maxCount
      if (finished) {
        finished(this.hasMoreData)
      }
    }, 1000)
  }

  pushData(data: Model): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

