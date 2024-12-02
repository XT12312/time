/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import Logger from './LoggerUtil';
import { CommonConstants } from '../common/constant/CommonConstants';
// import  xc  from '../pages/xiangce/xc';
import { router } from '@kit.ArkUI';

const TAG: string = 'imageEdit_Decode';

/**
 * Async get resource fd.
 *解码
 * @return file fd.
 */
async function getResourceFd(component: Object) {
  const context = getContext(component);
  const resourceMgr = context.resourceManager;
  const xx:string=(router.getParams() as Record<string, string>)['photo']
  const cc:number=Number(xx)
  let dd: Resource=$r(`app.media.img_1`)
  if(cc==1){
        dd=$r('app.media.img_1')
  }else if(cc==2){
    dd=$r('app.media.img_2')
  }else if(cc==3){
    dd=$r('app.media.img_3')
  }else if(cc==4){
    dd=$r('app.media.img_4')
  }else if(cc==5){
    dd=$r('app.media.img_5')
  }else if(cc==6){
    dd=$r('app.media.img_2')
  }else if(cc==7){
    dd=$r('app.media.img_3')
  }else if(cc==8){
    dd=$r('app.media.img_4')
  }else if(cc==9){
    dd=$r('app.media.img_5')
  }else if(cc==10){
    dd=$r('app.media.img_2')
  }else if(cc==11){
    dd=$r('app.media.img_3')
  }else if(cc==12){
    dd=$r('app.media.img_4')
  }else if(cc==13){
    dd=$r('app.media.img_5')
  }
  let imageBuffer = await resourceMgr.getMediaContent(dd)//原图片
  let filePath = context.cacheDir + '/' + CommonConstants.RAW_FILE_NAME;
  let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
  fileIo.writeSync(file.fd, imageBuffer.buffer);
  return file.fd;
}


/**
 * Async create pixel map.
 *
 * @return pixelMa.
 */
export default async function getPixelMap(component: Object) {//解码函数
  const fd = await getResourceFd(component);//创建图片实例
  const imageSourceApi = image.createImageSource(fd);//图片资源
  if (!imageSourceApi) {
    Logger.error(TAG, 'imageSourceAPI created failed!');
    return;
  }
  const pixelMap = await imageSourceApi.createPixelMap({
    editable: true
  });
  return pixelMap;//像素分布图
}