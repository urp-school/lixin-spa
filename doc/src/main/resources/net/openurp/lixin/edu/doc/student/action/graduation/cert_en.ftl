[#ftl/]
[#setting locale="en_US"]


[#function getMajor std]
  [#if (std.state.direction.enName)??]
    [#return ((std.state.major.enName)!'__')+ "(" + std.state.direction.enName +")" /]
  [#else]
    [#return (std.state.major.enName)!(std.state.major.name) /]
  [/#if]
[/#function]


<p ALIGN="left" style="margin-top:10px;FONT-SIZE:12pt;line-height:230%;letter-spacing:1px;text-align:justify;font-family: 'Times New Roman';">
This is to certify that ${(std.person.phoneticName)!"__"}, ${(std.person.gender.enName)!"__"}[#t/]
, student ID:${std.user.code},born on ${(std.person.birthday?string('dd MMMMM,yyyy'))!"_______"}, [#t/]
  attended a ${std.duration} year course in the Specialty of ${(std.state.major.enName)!'__'} a[#t/]
t this university from ${std.beginOn?string('MMMMM yyyy')} to ${std.endOn?string('MMMMM yyyy')} an[#t/]
  d has successfully fulfilled all the requirement of the prescribed course. Graduation is hereby granted. [#t/]
</p>