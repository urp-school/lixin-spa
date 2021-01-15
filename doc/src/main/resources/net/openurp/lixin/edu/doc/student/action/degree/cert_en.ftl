[#ftl/]
[#setting locale="en_US"]

[#function getApp gender]
  [#if gender??]
    [#if gender.id==2][#return "she"/][#else][#return "he"/][/#if]
  [#else]
    [#return "she/he"/]
  [/#if]
[/#function]

[#function getMajor std]
  [#if (std.state.direction.enName)??]
    [#return ((std.state.major.enName)!'__')+ "(" + std.state.direction.enName +")" /]
  [#else]
    [#return (std.state.major.enName)!(std.state.major.name) /]
  [/#if]
[/#function]


<p ALIGN="left" style="margin-top:10px;FONT-SIZE:12pt;line-height:230%;letter-spacing:1px;text-align:justify;font-family: 'Times New Roman';">
This is to certify that ${(std.person.phoneticName)!"__"}, ${(std.person.gender.enName)!"__"}[#t/]
, born on ${(std.person.birthday?string('dd MMMMM,yyyy'))!"_______"}, [#t/]
  has satisfactorily completed the prescribed undergraduate program of the Specialty o[#t/]
  f ${(std.state.major.enName)!'__'} at this university with qualified grades. I[#t/]
  n accordance with the regulations on <i>Academic Degree of the People’s Republic of China</i> [#t/]
  , ${getApp(std.person.gender)} has been awarded the bachelor’s Degree of ${(graduation.degree.enName)!"_______"}.[#t/]
</p>
