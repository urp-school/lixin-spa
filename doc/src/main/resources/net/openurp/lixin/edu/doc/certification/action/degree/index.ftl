<!DOCTYPE html>
[#if graduation?? ]
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
 <body style="padding:5mm 10mm 0mm 10mm;width: 280mm;margin: auto;">
    <div style="padding:0mm 10mm 0mm 10mm; height: 622px; text-align: center;">
      <p style="margin-top:45px"><span style="font-size:12pt;font-family: 'Times New Roman';">SHANGHAI LIXIN UNIVERSITY OF ACCOUNTING AND FINANCE</span></p>
      <p ALIGN="CENTER" style="margin-top:45px">
        <span style="font-size:20pt;font-family: 'Times New Roman';"><b>Certificate of  Bachelor’s Degree</b></span>
      </p>
      <p>&nbsp;</p>
      <div style="text-align: left; text-indent: 3em;">
          [#include "cert_en.ftl"/]
      </div>
      <div>
        <table>
          <tr>
            <td width="45%">
            </td>
            <td align="left">
              <p style="margin-top:60px"><span style="font-size:12pt;font-family: 'Times New Roman';"><b>President</b>:${graduation.president!}</span></p>
              <p style="margin-top:10px"><span style="font-size:12pt;font-family: 'Times New Roman';"><b>Organization</b>:Shanghai Lixin University of Accounting and Finance</span></p>
              <p style="margin-top:10px"><span style="font-size:12pt;font-family: 'Times New Roman';"><b>Chairman of Academic Degree Evaluation Committee</b></span></p>
              <img src="${base}/static/images/student_sig.jpg" style="height:42mm;width:42mm;margin-left: 30mm;margin-top: -130px;float:right;">
            </td>
          </tr>
          <tr>
            <td width="45%" align="left">
              <p style="margin-top:10px"><span style="font-size:12pt;font-family: 'Times New Roman';">Certificate No.:${graduation.serialNo!}</span></p>
            </td>
            <td align="center">
              <p style="margin-top:10px"><span style="font-size:12pt;text-align: right;font-family: 'Times New Roman';">Date:${(graduation.graduateOn?string("yyyy-MM-dd"))!}</span></p>
            </td>
          </tr>
        </table>
      </div>
    </div>
 </body>
  [#else ]目前不存在学位证书翻译
  [/#if]
[@b.foot/]
