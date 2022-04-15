[#ftl/]
[#setting locale="en_US"]

[#-- adjectival possessive pronoun--]
[#function getApp gender]
 [#if gender??]
   [#if gender.id==2][#return "she"/][#else][#return "he"/][/#if]
 [#else]
   [#return "she/he"/]
 [/#if]
[/#function]
[#function getAppBig gender]
  [#if gender??]
    [#if gender.id==2][#return "She"/][#else][#return "He"/][/#if]
  [#else]
    [#return "She/He"/]
  [/#if]
[/#function]
[#function getAppOne gender]
  [#if gender??]
    [#if gender.id==2][#return "Her"/][#else][#return "His"/][/#if]
  [#else]
    [#return "Her/His"/]
  [/#if]
[/#function]

[#function getMajor std]
  [#if (std.state.direction.enName)??]
    [#return ((std.state.major.enName)!'__')+ "(" + std.state.direction.enName +")" /]
  [#else]
    [#return (std.state.major.enName)!(std.state.major.name) /]
  [/#if]
[/#function]


<p ALIGN="left" style="margin-top:10px;FONT-SIZE:15pt;line-height:230%;letter-spacing:1px;text-align:justify;font-family: 'Times New Roman';">
[#assign gradeNameMap={'1':'first','2':'second','3':'third','4':'fourth','5':'fourth','6':'fourth'}/]
This is to certify that ${(std.person.phoneticName)!"__"}, ${(std.person.gender.enName)!"__"}[#t/]
, born on ${(std.person.birthday?string('dd MMMMM,yyyy'))!"_______"}, has been enrolled as a [#t/]
student majoring in ${(std.state.major.enName)!'__'} since ${std.beginOn?string('dd MMMMM,yyyy')}[#t/]
. ${getAppOne(std.person.gender)} student ID is ${std.user.code} and ${getApp(std.person.gender)} is current[#t/]
  ly studying in [#t/]
  the ${gradeNameMap[grade?string]} year of ${std.duration}-year educational system in Shanghai Lixin University of Accounting and Finance.[#t/]
  ${getAppBig(std.person.gender)} is supposed to graduate on ${(std.state.enOn?string('MMMMM,yyyy'))!(std.graduateOn?string('MMMMM,yyyy'))} under normal circumstance.[#t/]
</p>