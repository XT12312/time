

import { image } from '@kit.ImageKit';
import { IconStatus } from '../viewmodel/IconListViewModel';
import AdjustContentView from '../view/AdjustContentView';
import { cropIconChangeList, menuIconList } from '../viewmodel/IconListViewModel';
import Logger from '../utils/LoggerUtil';
import { RotateType, CropType, MainTabId } from '../viewmodel/OptionViewModel';
import { square, banner, rectangle } from '../utils/CropUtil';
import { encode } from '../utils/EncodeUtil';
import getPixelMap from '../utils/DecodeUtil';
import { CommonConstants } from '../common/constant/CommonConstants';
import { router, window } from '@kit.ArkUI';

const TAG: string = 'imageEdit';
@Entry
@Component
struct HomePage {
  @State currentIndex: number = 0;//状态根据build改变，当前
  @State currentCropIndex: number = 0;//裁剪
  @Provide('pixelMap') pixelMap?: image.PixelMap = undefined;//pixemap由入口组件提供给后代
  @Provide('imageInfo') imageInfo: image.ImageInfo = {
    size: { height: 0, width: 0 },
    density: 0,
    stride: 0,
    alphaType: 0,
    pixelFormat: 0,
    mimeType: '',
    isHdr: false
  };
  @Provide('currentAdjustData') currentAdjustData: Array<number> =
    CommonConstants.ADJUST_SLIDER_VALUE.map((item: number) => item);
  @Provide('isPixelMapChange') @Watch('flushPixelMap') isPixelMapChange: boolean = false;//图片是否改变
  menuIconChangeList = menuIconList;
  cropIconChange: Array<IconStatus> = cropIconChangeList;
  @State saveButtonOptions: SaveButtonOptions = {//保存
    icon: SaveIconStyle.FULL_FILLED,
    text: SaveDescription.SAVE_IMAGE,
    buttonType: ButtonType.Capsule
  }

  @Builder
  NavigationTitle() {
    Row() {
      Image($r('app.media.back1')).onClick(()=>router.back())
        .width(35)
        .height(20)
        .margin({
          top: 18,
          left: $r('app.float.title_margin_left')
        })
    }
  }

  @Builder
  TabBuilderMenu(index: number, name: string | Resource) {//各功能菜单
    Column() {
      Image(this.currentIndex === index ? this.menuIconChangeList[index]?.chosen :
        this.menuIconChangeList[index]?.normal)//选择状态和正常状态
        .width(CommonConstants.TAB_MENU_WIDTH)
        .height(CommonConstants.TAB_MENU_WIDTH)

      Text(name)
        .fontColor(this.currentIndex === index ? Color.Blue : Color.White)
        .fontSize($r('app.float.category_font_size'))
        .margin({ top: $r('app.float.category_margin_top') })
    }
    .width(CommonConstants.LAYOUT_FULL_SCREEN)
  }
//图片裁剪
  async cropImage(proportion: CropType) {//async/await是一种处理异步操作的方式
    if (!this.pixelMap) {//通过pixelMap调用接口crop()进行裁剪操作。
      return;
    }
    const imageInfo = await this.pixelMap.getImageInfo();//直到异步函数执行完
    const size = imageInfo.size;
    const imageWidth = size?.width;
    const imageHeight = size?.height;
    switch (proportion) {
      case CropType.ORIGINAL_IMAGE://原图
        this.pixelInit();
        break;
      case CropType.SQUARE://1：1
        if (this.pixelMap) {
          square(this.pixelMap, imageWidth, imageHeight).then(() => {
            this.flushPixelMapChange();
          });
        }
        break;
      case CropType.BANNER://4：3
        if (this.pixelMap) {
          banner(this.pixelMap, imageWidth, imageHeight).then(() => {
            this.flushPixelMapChange();
          });
        }
        break;
      case CropType.RECTANGLE://16：9
        if (this.pixelMap) {
          rectangle(this.pixelMap, imageWidth, imageHeight).then(() => {
            this.flushPixelMapChange();
          });
        }
        break;
      default:
        break;
    }
  }
//图片旋转
  rotateImage(rotateType: RotateType) {//通过pixelMap调用接口rotate()进行旋转操作。
    if (rotateType === RotateType.CLOCKWISE) {//顺时针旋转
      if (!this.pixelMap) {
        return;
      }
      try {
        this.pixelMap.rotate(CommonConstants.CLOCK_WISE)
          .then(() => {
            this.flushPixelMapChange();
          })
      } catch (error) {
        Logger.error(TAG, `there is a error in rotate process with ${error?.code}`);
      }
    }
    if (rotateType === RotateType.ANTI_CLOCK) {//逆时针旋转
      if (!this.pixelMap) {
        return;
      }
      try {
        this.pixelMap.rotate(CommonConstants.ANTI_CLOCK)
          .then(() => {
            this.flushPixelMapChange();
          })
      } catch (error) {
        Logger.error(TAG, `there is a error in rotate process with ${error?.code}`);
      }
    }
  }

  flushPixelMapChange() {//刷新
    this.isPixelMapChange = !this.isPixelMapChange;
  }

  flushPixelMap() {
    const temp = this.pixelMap;
    this.pixelMap = undefined;
    this.pixelMap = temp;
  }

  pixelInit() {
    getPixelMap(this)//获取图片像素信息
      .then((pixelMap?: image.PixelMap) => {//第一个参数为成功回调，第二个为失败回调
        if (pixelMap) {
          this.isPixelMapChange = !this.isPixelMapChange;//改变状态值取反
          this.pixelMap = pixelMap;
        }
        this.currentCropIndex = 0;
        this.currentAdjustData = CommonConstants.ADJUST_SLIDER_VALUE.map((item: number) => item);
      })
  }

  aboutToAppear() {//生命周期起始
    this.pixelInit();
  }

  @Builder
  TitleNavigation() {//菜单
    Row({ space: CommonConstants.TITLE_SPACE }) {
      Button() {
        Image($r('app.media.ic_reset'))
          .width($r('app.float.title_image_width'))
          .height($r('app.float.title_image_height'))
      }
      .height(CommonConstants.LAYOUT_FULL_SCREEN)
      .type(ButtonType.Normal)
      .aspectRatio(1)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        this.pixelInit();
      })

      SaveButton(this.saveButtonOptions)//保存图片
        .onClick(() => {
          AlertDialog.show({
            title: $r('app.string.save_image'),
            message: $r('app.string.confirm_save'),
            alignment: DialogAlignment.Center,
            primaryButton: {
              value: $r('app.string.save'),
              action: () => {
                if (this.pixelMap) {
                  encode(this, this.pixelMap);//编码
                }
              }
            },
            secondaryButton: {//取消
              value: $r('app.string.cancel'),
              action: () => {
                Logger.info(TAG, `cancel`);
              }
            }
          })
        })
    }
  }

  build() {
    Navigation() {//页面导航菜单栏
      Stack() {
        Column() {
          Column() {//图片
            if (this.isPixelMapChange) {
              Image(this.pixelMap)//将解析好的pixelMap通过Image组件加载显示
                .objectFit(ImageFit.None)//图片保持原有尺寸
            }
            else {
              Image(this.pixelMap)
                .objectFit(ImageFit.None)
            }
          }
          .width(CommonConstants.LAYOUT_FULL_SCREEN)
          .height(CommonConstants.IMAGE_SHOW_HEIGHT)

          Column() {
            Tabs({ barPosition: BarPosition.End }) {//容器组件可包含多个选项卡 设置在底部
              TabContent() {//裁剪选项卡
                Row() {
                  ForEach(this.cropIconChange, (item: IconStatus, index?: number | undefined) => {//循环渲染
                    Image(this.currentCropIndex === index ? item?.chosen : item?.normal)
                      .width($r('app.float.crop_image_width'))
                      .height($r('app.float.crop_image_height'))
                      .onClick(() => {
                        if (typeof (index) === 'number') {
                          this.currentCropIndex = index;
                          this.cropImage(index);//图片裁剪
                        }
                      })
                  }, (item: IconStatus) => JSON.stringify(item))//转化为字符串
                }
                .width(CommonConstants.LAYOUT_FULL_SCREEN)
                .height(CommonConstants.LAYOUT_FULL_SCREEN)
                .justifyContent(FlexAlign.SpaceAround)
              }
              .tabBar(this.TabBuilderMenu(MainTabId.CROP, $r('app.string.crop')))//多个内容视图之间进行切换

              TabContent() {//旋转选项卡
                Row() {
                  Image($r('app.media.ic_clockwise'))
                    .width($r('app.float.rotate_image_width'))
                    .height($r('app.float.rotate_image_height'))
                    .margin({ right: CommonConstants.EDIT_PAGE_HEIGHT })
                    .onClick(() => {
                      this.rotateImage(RotateType.CLOCKWISE);//顺时针
                    })
                  Image($r('app.media.ic_anti_clockwise'))
                    .width($r('app.float.rotate_image_width'))
                    .height($r('app.float.rotate_image_height'))
                    .onClick(async () => {
                      this.rotateImage(RotateType.ANTI_CLOCK);//逆时针
                    })
                }
                .justifyContent(FlexAlign.Center)
                .width(CommonConstants.LAYOUT_FULL_SCREEN)
                .height(CommonConstants.LAYOUT_FULL_SCREEN)
              }
              .tabBar(this.TabBuilderMenu(MainTabId.ROTATE, $r('app.string.rotate')))

              TabContent() {//调节选项卡
                AdjustContentView()
              }
              .tabBar(this.TabBuilderMenu(MainTabId.ADJUST, $r('app.string.adjust')))
            }
            .scrollable(false)
            .onChange((index: number) => {
              this.currentIndex = index;
            })
          }
          .width(CommonConstants.LAYOUT_FULL_SCREEN)
          .height(CommonConstants.EDIT_PAGE_HEIGHT)
          .backgroundColor(Color.Black)
        }
        .width(CommonConstants.LAYOUT_FULL_SCREEN)
        .height(CommonConstants.LAYOUT_FULL_SCREEN)
        .backgroundColor(Color.Black)
      }
    }//菜单栏属性
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor(Color.Black)
    .title(this.NavigationTitle())
    .hideBackButton(true)
    .menus(this.TitleNavigation())
  }
  onPageShow(): void {    //设置全屏的方法
    window.getLastWindow(AppStorage.get('context'), (err, data) => {
      if (err.code) {
        console.error('Failed to get last window.Cause:' + JSON.stringify(err))
        return
      }
      data.setFullScreen(true)
    })
  }
}