#!/bin/bash

IFS=$'\n\t'

appID=your appID
appSecret=your appSecret
IP=$(ifconfig en0 |awk -F ' *|:' '/inet /{print $2}')

# 获取token Url
GURL="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=$appID&secret=$appSecret"
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

templateID=UojN8BGUuanfBN1ecaC59oyCjfcygCsEhOYuHUn331o
# 发送模版消息
TPURL="https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=$Gtoken"

Msg="$(date)\nHostname: $(hostname)\nIP: ${IP}\n$@"
Body='{"touser": "'$openID'", "msgtype": "text", "text": {"content": "'${Msg}'"}}'
TBody='{"touser":"'$openID'","template_id":"'$templateID'","url":"https://abone.xyz","data":{"first":{"value":"恭喜你购买成功！","color":"#173177"},"keyword1":{"value":"巧克力","color":"#173177"},"keyword2":{"value":"39.8元","color":"#173177"},"keyword3":{"value":"2014年9月22日","color":"#173177"},"remark":{"value":"欢迎再次购买！","color":"#173177"}}}'
# TBody='{"touser":"'$openID'","template_id":"'$templateID'","url":"http://weixin.qq.com/download","topcolor":"#FF0000","data":{"User":{"value":"黄先生","color":"#173177"},"Date":{"value":"06月07日 19时24分","color":"#173177"},"CardNumber":{"value":"0426","color":"#173177"},"Type":{"value":"消费","color":"#173177"},"Money":{"value":"人民币260.00元","color":"#173177"},"DeadTime":{"value":"06月07日19时24分","color":"#173177"},"Left":{"value":"6504.09","color":"#173177"}}}'
# 推送消息
/usr/bin/curl --data-ascii $TBody --url ${TPURL}
echo

