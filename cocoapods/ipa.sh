#!/usr/bin/bash
#############################################
# batch rename                                 #
# Input  :    $1 SCHEME                      #
#             eg:需要编译的scheme                #
# Input  :    $2 PROVISION PREFIX           #
#             eg: mobileprovision文件的名称    #
#############################################

#next test
#1.证书
#2.打包状态每部判断

#设置Xcode的Build Settings->Code Signing Resource Rules Path的值为:$(SDKROOT)/ResourceRules.plist 


 #xcodeproj文件的绝对路径[修改]
WORKSPACE_PATH="/Users/HuiYan/Desktop/XM/HekrSDKAPP/"
WORKSPACE_NAME="HekrSDKAPP"
SCHEME="HekrSDKAPP"

#生成的APP名称，根据xcode项目 plist来定
APPNAME="HekrSDKAPP"

#iPhone Distribution: FOO.
IDENTITY="iPhone Distribution: Liting Su (6WDB9C7995)"

#Distribution Provision(hoc) File Path
PROVISIONING_PROFILE="/Users/HuiYan/Library/MobileDevice/Provisioning Profiles/0961cbdd-6158-40ff-a07f-5d452dc821ba.mobileprovision"

#输出ipa文件的路径, 最好是绝对路径
OUTDIR="/Users/HuiYan/Desktop/aaaa/"

#FIR 秘钥
FIRTOKEN="9627b35f4b868484aad68122081518f7"
#蒲公英aipKey
PAPIKEY="1bff144a78d54387961145f3eb81ac32"
#蒲公英uKey
PUKEY="7c000d185795582233acf8e993539ae9"


if [ ! -f $PROVISIONING_PROFILE ]; then
    echo "Please download the provision file for " ${PROVISIONING_PROFILE}
    exit 4;
fi
echo "~~~~~~~~~~~编译工程~~~~~~~~~"
echo "${OUTDIR}${APPNAME}.ipa"
echo "xcodebuild -workspace ${WORKSPACE_NAME}.xcworkspace -scheme ${SCHEME} -configuration  Debug clean build CODE_SIGN_IDENTITY=${IDENTITY} -sdk iphoneos CONFIGURATION_BUILD_DIR=${OUTDIR}"
xcodebuild -workspace "${WORKSPACE_PATH}/${WORKSPACE_NAME}.xcworkspace" \
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


#上传到测试平台 -> fir.im
echo "-------------------->fir.im------->蒲公英---------"
# ->  fir
#fir p "${OUTDIR}/${SCHEME}.ipa" -T "${FIRTOKEN}"
# ->  蒲公英
echo "curl -F file=@${OUTDIR}/${APPNAME}.ipa -F uKey=${PUKEY} -F _api_key=${PAPIKEY} http://www.pgyer.com/apiv1/app/upload"
curl -F "file=@${OUTDIR}/${APPNAME}.ipa" -F "uKey=${PUKEY}" -F "_api_key=${PAPIKEY}" "http://www.pgyer.com/apiv1/app/upload"
echo "\n\n"

#--------------------end--------------
