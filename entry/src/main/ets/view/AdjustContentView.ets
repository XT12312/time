/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *将pixelMap转换成ArrayBuffer。
将生成好的ArrayBuffer发送到worker线程。
对每一个像素点的亮度值按倍率计算。
将计算好的ArrayBuffer发送回主线程。
将ArrayBuffer写入pixelMap，刷新UI。
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { image } from '@kit.ImageKit';
import { worker, MessageEvents } from '@kit.ArkTS';
import { adjustIconList, IconStatus } from '../viewmodel/IconListViewModel';
import { adjustOpacity } from '../utils/OpacityUtil';
import { CommonConstants } from '../common/constant/CommonConstants';
import { AdjustId } from '../viewmodel/OptionViewModel';
import { MessageItem } from '../viewmodel/MessageItem';
import Logger from '../utils/LoggerUtil';


@Component
export default struct AdjustContentView {//色域调整视图
  @Builder
  TabBuilder(index: number, name: string | Resource) {
    Column() {//各功能
      Image(this.currentAdjustIndex === index ? this.AdjustIconList[index]?.chosen : this.AdjustIconList[index]?.normal)//点击颜色变化
        .width($r('app.float.adjust_icon_width'))
        .height($r('app.float.adjust_icon_height'))

      Text(name)
        .fontColor(this.currentAdjustIndex === index ? Color.Blue : Color.White)
        .fontSize($r('app.float.adjust_font_size'))
        .margin({ top: $r('app.float.adjust_margin_top') })
    }
    .width(CommonConstants.LAYOUT_FULL_SCREEN)
  }

  @State currentAdjustIndex: number = 0;
  @Consume('currentAdjustData') currentAdjustData: Array<number>;
  AdjustIconList: Array<IconStatus> = adjustIconList;//调节图片图标列表

  build() {
    Tabs({ barPosition: BarPosition.End }) {//底部显示
      TabContent() {
        SliderCustom({//亮度滑动条
          currentIndex: AdjustId.BRIGHTNESS.valueOf(),
          min: CommonConstants.SLIDER_MIN.valueOf(),
          max: CommonConstants.SLIDER_MAX.valueOf(),
          currentAdjustData: this.currentAdjustData
        })
      }
      .tabBar(this.TabBuilder(AdjustId.BRIGHTNESS, $r('app.string.brightness')))

      TabContent() {
        SliderCustom({//透明度滑动条
          currentIndex: AdjustId.TRANSPARENCY.valueOf(),
          min: CommonConstants.SLIDER_MIN.valueOf(),
          max: CommonConstants.SLIDER_MAX.valueOf(),
          currentAdjustData: this.currentAdjustData
        })
      }
      .tabBar(this.TabBuilder(AdjustId.TRANSPARENCY, $r('app.string.transparency')))

      TabContent() {
        SliderCustom({//饱和度滑动条
          currentIndex: AdjustId.SATURATION.valueOf(),
          min: CommonConstants.SLIDER_MIN.valueOf(),
          max: CommonConstants.SLIDER_MAX.valueOf(),
          currentAdjustData: this.currentAdjustData
        })
      }
      .tabBar(this.TabBuilder(AdjustId.SATURATION, $r('app.string.saturation')))
    }
    .margin({ bottom: $r('app.float.adjust_margin_bottom') })
    .onChange((index: number) => {//接收输入数字变化
      this.currentAdjustIndex = index;
    })
  }
}

@Component
struct SliderCustom {
  @Prop currentIndex: number;//单向
  @Link currentAdjustData: number[];//双向
  @Prop min: number;
  @Prop max: number;
  @Consume('pixelMap') pixelMap?: image.PixelMap;
  @Consume('isPixelMapChange') isPixelMapChange: boolean;
  private postState: boolean = true;
  saturationLastSlider: number = CommonConstants.SLIDER_MAX;//饱和度100
  brightnessLastSlider: number = CommonConstants.SLIDER_MAX;//亮度100
  deviceListDialogController: CustomDialogController = new CustomDialogController({//自定义弹窗
    builder: Dialog(),
    alignment: DialogAlignment.Center,
    autoCancel: false,
    customStyle: true
  });

  build() {
    Column() {
      Text(`${this.currentAdjustData[this.currentIndex]}`)//滑动条数字
        .fontColor(Color.White)
        .margin({ top: $r('app.float.slider_margin_top') })
        .fontSize($r('app.float.slider_font_size'))
      Row() {//滑动条
        Slider({
          value: this.currentAdjustData[this.currentIndex],
          step: CommonConstants.SLIDER_STEP,
          min: this.min,
          max: this.max
        })
          .trackColor(Color.White)
          .width(CommonConstants.SLIDER_WIDTH)
          .showSteps(true)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.sliderChange(value > this.max ? this.max : value, mode);
          })
      }
      .width(CommonConstants.LAYOUT_FULL_SCREEN)
      .justifyContent(FlexAlign.Center)
    }
  }

  sliderChange(value: number, mode: SliderChangeMode) {//改变图片
    if ((mode === SliderChangeMode.End) && (value !== this.currentAdjustData[this.currentIndex])) {
      this.currentAdjustData[this.currentIndex] = Math.round(value);
      switch (this.currentIndex) {
        case AdjustId.BRIGHTNESS:
          this.postToWorker(AdjustId.BRIGHTNESS, value, CommonConstants.BRIGHTNESS_WORKER_FILE);
          break;
        case AdjustId.TRANSPARENCY:
          if (this.pixelMap) {
            adjustOpacity(this.pixelMap, Math.round(value))
              .then((pixelMap?: image.PixelMap) => {
                if (pixelMap) {
                  this.pixelMap = pixelMap;
                  this.isPixelMapChange = !this.isPixelMapChange;
                }
              });
          }
          break;
        case AdjustId.SATURATION://饱和
          this.postToWorker(AdjustId.SATURATION, value, CommonConstants.SATURATION_WORKER_FILE);
          break;
        default:
          break;
      }
    }
  }
//转化成pixelMap及发送buffer到worker，返回数据刷新ui
  postToWorker(type: AdjustId, value: number, workerName: string) {//改变图片函数
    if (!this.pixelMap) {
      return;
    }
    let sliderValue = type === AdjustId.BRIGHTNESS ? this.brightnessLastSlider : this.saturationLastSlider;
    let workerInstance = new worker.ThreadWorker(workerName);
    const bufferArray = new ArrayBuffer(this.pixelMap.getPixelBytesNumber());
    this.pixelMap.readPixelsToBuffer(bufferArray)
      .then(() => {
        let message = new MessageItem(bufferArray, sliderValue, value);
        workerInstance.postMessage(message);
        if (this.postState) {
          this.deviceListDialogController.open();
        }
        this.postState = false;
        workerInstance.onmessage = (event: MessageEvents) => {
          this.updatePixelMap(event);
          workerInstance.terminate();
        }
        if (type === AdjustId.BRIGHTNESS) {
          this.brightnessLastSlider = Math.round(value);
        } else {
          this.saturationLastSlider = Math.round(value);
        }
        workerInstance.onexit = () => {
          if (workerInstance !== undefined) {
            workerInstance.terminate();
            Logger.info('AdjustContentView', 'main thread terminate');
          }
        }
      });
  }

  updatePixelMap(event: MessageEvents) {//更新
    const newPixel = this.pixelMap as image.PixelMap;
    newPixel.writeBufferToPixels(event.data);
    this.pixelMap = newPixel;
    this.isPixelMapChange = !this.isPixelMapChange;
    this.deviceListDialogController.close();
    this.postState = true;
  }
}

@CustomDialog
export struct Dialog {
  controller?: CustomDialogController;

  build() {
    Column() {
      LoadingProgress()//用于显示加载动效的组件
        .color(Color.White)
        .width(CommonConstants.LOADING_WH)
        .height(CommonConstants.LOADING_WH)
    }
  }
}
