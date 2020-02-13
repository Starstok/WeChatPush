#!/bin/bash

IFS=$'\n\t'

appID=your appID
appSecret=your appSecret
IP=$(ifconfig en0 |awk -F ' *|:' '/inet /{print $2}')

# 获取token Url
GURL="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appID=$appID&secret=$appSecret"
echo "GURL: "$GURL
# 请求获取token
Gtoken=$(/usr/bin/curl -s -G $GURL | awk -F\" '{print $4}')
echo "Gtoken: "$Gtoken

# 获取用户列表
UseListUrl="https://api.weixin.qq.com/cgi-bin/user/get?access_token=$Gtoken&next_openID="
openID=$(/usr/bin/curl -s -G $UseListUrl | awk -F\" '{print $10}')
echo "openID: "$openID
# 发送客服消息
PURL="https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=$Gtoken"

# 发送模版消息
TPURL="https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=$Gtoken"

Msg="$(date)\nHostname: $(hostname)\nIP: ${IP}\n$@"
Body='{"touser": "'$openID'", "msgtype": "text", "text": {"content": "'${Msg}'"}}'
# 推送消息
/usr/bin/curl --data-ascii $Body --url ${PURL}
echo
