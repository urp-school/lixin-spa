[#ftl]
<p ALIGN="left" style="margin-top:10px;font-size:15pt;line-height:65px;letter-spacing:1px;text-align:justify; text-justify:inter-ideograph;font-family: FangSong_GB2312;word-break:break-all;">
${std.user.name}，${(std.person.gender.name)!}，[#t/]
[#if std.person.birthday??]${std.person.birthday?string('yyyy年MM月dd日')}[#else]&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;月&nbsp;&nbsp;日[/#if][#t/]
出生。于${std.beginOn?string("yyyy年MM月dd日")}起就读于我校${std.state.department.name}&nbsp;[#t/]
${(std.state.major.name)!}专业(${std.level.name})，学制${std.duration}年，学号${std.user.code}，正常情况下将于${(std.state.enOn?string('yyyy年MM月dd日'))!(std.graduateOn?string('yyyy年MM月dd日'))}毕业。
</p>
