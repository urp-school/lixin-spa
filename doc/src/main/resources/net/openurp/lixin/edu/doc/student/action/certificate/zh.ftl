<!DOCTYPE html>
<html lang="zh_CN">
  <head>
    <title></title>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta http-equiv="pragma" content="no-cache"/>
    <meta http-equiv="cache-control" content="no-cache"/>
    <meta http-equiv="expires" content="0"/>
    <meta http-equiv="content-style-type" content="text/css"/>
    <meta http-equiv="content-script-type" content="text/javascript"/>
 </head>
 <body style="padding:5mm 10mm 0mm 10mm;width: 180mm;margin: auto;margin:auto;">
     <div style="height:722px;text-align:center;">
       <img src="${base}/static/images/schoolName.png" style="height:15mm;margin-top: 30px;">
       <div style="margin-top:30px;border-bottom:1px solid #000;"></div>
       <div style="margin-top:2px;border-bottom:1px solid #000;"></div>
       <div style="margin-top:50px;"> <h1 ALIGN="CENTER"><span style="letter-spacing:20px;font-family: SimHei">在读证明</span></h1></div>
        <p>&nbsp;</p>
        <div style="text-align:left;text-indent:3em;">
            [#include "cert_zh.ftl"/]
        <p>&nbsp;</p>
        <p>&nbsp;</p>
        <p>&nbsp;</p>
        </div>

       <div style="float:right;text-align: right;">
         <p style="margin-top:40px"><span style="font-size:16pt;font-family: FangSong_GB2312"><b>上海立信会计金融学院</b></span></p>
         <p style="margin-top:10px"><span style="font-size:16pt ;font-family:FangSong_GB2312"><b>教务处</b></span></p>
         <p style="margin-top:20px"><span style="font-size:16pt;font-family: FangSong_GB2312"><b>${b.now?string('yyyy年MM月dd日')}</b></span></p>
         <img src="${base}/static/images/student_sig.jpg" style="height:42mm;width:42mm;margin-left: 30mm;margin-top: -130px;">
       </div>
    </div>

 </body>
[@b.foot/]