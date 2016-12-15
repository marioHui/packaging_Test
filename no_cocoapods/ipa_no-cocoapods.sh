#!/usr/bin/bash

#next test
#1.证书
#2.打包状态每部判断

#设置Xcode的Build Settings->Code Signing Resource Rules Path的值为:$(SDKROOT)/ResourceRules.plist 


 #xcodeproj文件的绝对路径
PROJECT="/Users/mac/Desktop/test.xcodeproj"

SCHEME="test"

#生成的APP名称，根据xcode项目 plist来定
APPNAME="test"

#iPhone Distribution:
IDENTITY="iPhone Distribution: xxxxxxx (xxxxxxxx)"

#Distribution Provision(hoc) File Path
PROVISIONING_PROFILE="/Users/mac/Library/MobileDevice/Provisioning Profiles/0961cbdd-6158-40ff-a07f-5d452dc821ba.mobileprovision"

#输出ipa文件的路径, 最好是绝对路径
OUTDIR="/Users/mac/Desktop/testipa/"

PRODUCTDIR=${OUTDIR}
#FIR 秘钥
FIRTOKEN="9627b35f4b868484xxxxxxxxxxxxxx"
#蒲公英aipKey
PAPIKEY="1bff144a78d543879xxxxxxxxxxxxxxx"
#蒲公英uKey
PUKEY="7c000d18579558223xxxxxxxxxxxxxxxxx"

if [ ! -f $PROVISIONING_PROFILE ]; then
    echo "Please download the provision file for "${PROVISIONING_PROFILE}
    exit 4;
fi
echo "~~~~~~~~~~~编译工程~~~~~~~~~"
echo "${OUTDIR}${APPNAME}.ipa"
echo "xcrun -sdk iphoneos PackageApplication -v ${PRODUCTDIR}/${SCHEME}.app -o ${OUTDIR}/${SCHEME}.ipa --sign ${IDENTITY} --embed ${PROVISIONING_PROFILE}"
xcodebuild -project "${PROJECT}" \
-scheme "${SCHEME}" \
-configuration  Debug \
clean \
build \
-derivedDataPath "${OUTDIR}"
if [ ! -f "${OUTDIR}/Build/Products/Debug-iphoneos/${APPNAME}.app" ]; then
echo "----xcodebuild failed-----"
fi
#打包成 .ipa
xcrun -sdk iphoneos PackageApplication \
-v "${OUTDIR}/Build/Products/Debug-iphoneos/${APPNAME}.app" \
-o "${OUTDIR}/${APPNAME}.ipa"
# --sign "\"${IDENTITY}\"" --embed "${PROVISIONING_PROFILE}"


#上传到测试平台 -> fir.im
echo "-------------------->fir.im------->蒲公英---------"
# ->  fir
#fir p "${OUTDIR}/${SCHEME}.ipa" -T "${FIRTOKEN}"
# ->  蒲公英
echo "curl -F file=@${OUTDIR}/${APPNAME}.ipa -F uKey=${PUKEY} -F _api_key=${PAPIKEY} http://www.pgyer.com/apiv1/app/upload"
curl -F "file=@${OUTDIR}/${APPNAME}.ipa" -F "uKey=${PUKEY}" -F "_api_key=${PAPIKEY}" "http://www.pgyer.com/apiv1/app/upload"
echo "\n\n"
