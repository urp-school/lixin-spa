[#ftl]
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="content-type" content="text/html;charset=utf-8" />
  <meta http-equiv="pragma" content="no-cache"/>
  <meta http-equiv="cache-control" content="no-cache"/>
  <meta http-equiv="expires" content="0"/>
</head>
<body  style="font-size:13px;">
<div style="height:18mm">&nbsp;</div>
[#assign fontsize=10/]
    <style>
        .semester{
            text-align:center;
            font-size:16px;
            font-family:微软雅黑;
            border-top:2px #000 solid;
            border-right:2px #000 solid;
            border-left:2px #000 solid;
            border-bottom:2px #000 solid;
        }
        .blank{
            text-align:center;
            font-size:16px;
            font-family:微软雅黑;
            border-right:2px #000 solid;
            border-left:2px #000 solid;
        }
        .tds{
            text-align:center;
        }
        .tableclass{
            border-collapse:collapse;
            font-size:14px;
            border-top:2px #000 solid;
            border-right:2px #000 solid;
            border-left:2px #000 solid;
            border-bottom:2px #000 solid;
        }
        .titlecss{
            text-align:center;
            font-size:14px;
            width:250px;
            font-family:微软雅黑;
        }
        .titlescore{
        	text-align:center;
            font-size:14px;
            font-family:微软雅黑;
            width:40px;
        }
        .title{
            text-align:center;
            font-size:14px;
            font-family:微软雅黑;
            width:70px;
        }
    </style>
    [#--最大成绩行数--]


    [#assign maxRows = 50/]
    [#assign colmns = 3/]
    [#assign maxCols = 4*colmns/]
    [#--每列最大学期数--]
[#list students as std]
   [#assign schoolName]${school.name}[/#assign]
    [#assign stdTypeName = std.stdType.name /]
    <div  style="width:1460px;padding-left:0px;[#if std_index>0]PAGE-BREAK-BEFORE: always[/#if]">
    <table  width="100%" valign='top' >
        <tr><td colspan="5" align="center"><h1>${schoolName}${(std.state.grade + "级")?replace("-3级","(春季)级")?replace("-9级","(秋季)级")}${stdTypeName}学生成绩单表</h1></td></tr>
        <tr style="font-size:14px">
         <td >层&nbsp;&nbsp;&nbsp;&nbsp;次：${std.level.name}</td>
         <td >专&nbsp;&nbsp;&nbsp;&nbsp;业：${(std.major.name)?default("")}</td>
         <td >姓&nbsp;&nbsp;&nbsp;&nbsp;名：${std.name}</td>
         <td >学&nbsp;&nbsp;&nbsp;&nbsp;号：${((std.user.code)?default(""))?trim}</td>
         <td >性别：${((std.person.gender.name)?default(""))?trim}</td>
        </tr>
    </table>
    <table width='100%' border="1" id="transcript${std.id}" class="tableclass">
            [#list 1..maxRows as row]
                [#--此处的tr和td中不能有空格，否则影响js中的nextSibling--]
                <tr height='20px'>[#list 0..(maxCols-1) as col]<td id="transcript${std.id}_${(col/colmns)?int*colmns*maxRows+(col%colmns)+(row-1)*colmns}" [#if (col+1)%colmns==0] style="border-right:2px #000 solid;" [/#if] [#if col>colmns][#if col%colmns==0 ] width="250px"  [#else]   width="50px" [/#if][/#if]>&nbsp;</td>[/#list]</tr>
            [/#list]
    </table>
    <script>
    var index=0;
    var semesterCourses={};
    var nowsemsenumber=0;
    var blankRow=0;
    var array =[];
    var colmns=3;
    //统计学期总个数，并且去掉重复元素
    function semsernumber(semsename){
         array.push(semsename);
         array = array || [];
         var a = {};
        for (var i=0; i<array.length; i++) {
            var v = array[i];
            if (typeof(a[v]) == 'undefined'){
                a[v] = 1;
            }
        };
        array.length=0;
        for (var i in a){
           array[array.length] = i;
        }
    }

    //移除重复元素
    function unique(){
        data = data || [];
        var a = {};
        for (var i=0; i<data.length; i++) {
            var v = data[i];
            if (typeof(a[v]) == 'undefined'){
                a[v] = 1;
            }
        };
        data.length=0;
        for (var i in a){
            data[data.length] = i;
        }
        return data.length;
   }

    //添加学期和以下空白等说明
    function setTitle(table,tbindex,value){
        var td = document.getElementById(table+"_"+tbindex);
        td.innerHTML=value;
        for(i=0;i<colmns-1;i++){
          td.parentNode.removeChild(td.nextSibling);
        }
        td.colSpan=colmns;
        if(value!="以下空白"){
            td.className="semester";
        }else{
            td.className="blank";
        }
    }
    function calcRow(tdindex){
        return parseInt(tdindex/(${maxRows}*colmns))*colmns + tdindex%colmns;
    }

    function calcCol(tdindex){
        return parseInt((tdindex-parseInt(tdindex/(${maxRows}*colmns))*colmns*${maxRows})/colmns) +1;
    }

    //添加表头
    function addtitle(table){
        var col = calcRow(index);
        var row = calcCol(index);
        if(row>${maxRows} || col >= ${maxCols}) {
            return;
        }
        document.getElementById(table+"_"+(index)).className="titlecss";
        document.getElementById(table+"_"+(index)).innerHTML="课程名称";
        document.getElementById(table+"_"+(index+1)).className="titlescore";
        document.getElementById(table+"_"+(index+1)).innerHTML="学分";
        document.getElementById(table+"_"+(index+2)).className="title";
        document.getElementById(table+"_"+(index+2)).innerHTML="成绩";
        index+=colmns;
    }
    //添加学年学期
    function addSemester(table,semesterId,value){
        nowsemsenumber++;//当前是第几个学期
        var col = calcRow(index);
        var row = calcCol(index);
        var myCourseCnt= semesterCourses['c'+semesterId];
        if(row>${maxRows} || col >= ${maxCols}) {
            return;
        }
        if(array.length<=8 &&( nowsemsenumber==3 || nowsemsenumber ==5 || nowsemsenumber ==7)){
            //转到下一列的第一行
            addBlank(table);
            index=${maxRows}*(col+colmns);
            if(calcRow(index)>${maxRows}|| calcCol(index) >= ${maxCols}) {return;}
        }
        if( array.length>8 && (${maxRows} - row-1) < myCourseCnt){
            //转到下一列的第一行
            addBlank(table);
            index=${maxRows}*(col+colmns);
            if(calcRow(index)>${maxRows}|| calcCol(index) >= ${maxCols}) {return;}
        }
        setTitle(table,index,value);
        index+=colmns;
    }

    //添加以下空白
    function addBlank(table){
        var col = calcRow(index);
        var row = calcCol(index);
        if(row>${maxRows}|| col >= ${maxCols}) {return;}
        //空白行不放在第一行
        if(row==1)return;
        setTitle(table,index,"以下空白");
    }

    function addScore(table,name,courseTypeName,credit,score, type, code, examState, subCourseCode, courseGradeId, schoolYear){
    	var timeStr="2017-2018";
        var codeArray=code.split("_");
        var subCourseCodeArray=subCourseCode.split("_");
        var i;
    	var typeStr="(";
    	if(schoolYear >= timeStr){
	    	if(type==3){
	    		typeStr+="重修/";
	        }
	        if(type==5){
	        	typeStr+="免修/";
	        }

	        for(i=0; i<codeArray.length; i++){
	        	if(codeArray[i] == "4"){
	        		typeStr+="补考/";
	        	}else if(codeArray[i] == "6"){
	        		typeStr+="缓考/";
	        	}
	        }
	        for(i=0; i<subCourseCodeArray.length; i++){
	        	if(subCourseCodeArray[i] == courseGradeId){
	        		typeStr+="替代/";
	        		break;
	        	}
	        }
	        if(examState == 1){
	        	typeStr+="缺/";
	        }
	        if(typeStr.length > 1){
	        	typeStr=typeStr.substring(0, typeStr.length-1);
	        }
	    }
        typeStr+=")";
        if(typeStr.length == 2){
        	typeStr="";
        }
        var col = calcRow(index);
        var row = calcCol(index);
        if(row>${maxRows} || col >= ${maxCols}) {return;}
        document.getElementById(table+"_"+(index)).innerHTML=name;
        document.getElementById(table+"_"+(index+1)).className="tds";
        document.getElementById(table+"_"+(index+2)).className="tds";
        document.getElementById(table+"_"+(index+1)).innerHTML=credit;
       	document.getElementById(table+"_"+(index+2)).innerHTML=(score+"<font style='font-size:10px; color:red'>"+typeStr+"</font>");
        index+=colmns;
        if (blankRow<row){
            blankRow=row;
        }
    }
    /**累计每学期课程*/
    function addSemesterCourse(semesterId){
        //学年学期占一行,所以初始为1
        if(typeof semesterCourses['c'+semesterId] == "undefined")
            semesterCourses['c'+semesterId]=1;
        else semesterCourses['c'+semesterId]= semesterCourses['c'+semesterId]+1;
    }
    [#assign subCourseCode=""]
    [#assign subCourseList=subCourseMap.get(std)]
    [#list subCourseList as subCourse]
        [#assign subCourseCode=subCourseCode+subCourse]
        [#if subCourse_has_next]
            [#assign subCourseCode=subCourseCode+"_"]
        [/#if]
    [/#list]

    [#list grades.get(std) as g]addSemesterCourse('${g.semester.id}');semsernumber('${g.semester.id}');[/#list]
    [#assign semester_id=0]
    [#list grades.get(std)?sort_by(["course","code"])?sort_by(["semester","beginOn"])  as courseGrade]
        [#if courseGrade.semester.id  != semester_id]
            [#assign semester_id=courseGrade.semester.id]
            addSemester("transcript${std.id}",'${courseGrade.semester.id}','${courseGrade.semester.schoolYear!}'+"学年第"+'[#if courseGrade.semester.name='1']一[#elseif courseGrade.semester.name='2']二[#else]${courseGrade.semester.name}[/#if]'+"学期");
            addtitle("transcript${std.id}");
        [/#if]
        [#assign examState=0]
        [#assign code=""]
        [#list courseGrade.examGrades! as grade]
        	[#assign code=code+grade.gradeType.id]
        	[#if grade.examStatus.id == 3]
        		[#assign examState=1]
        	[/#if]
        	[#if grade_has_next]
        		 [#assign code=code+"_"]
        	[/#if]
        [/#list]

        addScore("transcript${std.id}" ,'${courseGrade.course.name}','${courseGrade.course.code[0..0]}','${courseGrade.course.credits!}',
        [#if !exchangeCourse(std,courseGrade.course,courseGrade.semester)]
        '${courseGrade.scoreText!}',
        [#else]
        '免修',
        [/#if]
        '${courseGrade.courseTakeType.code!}', '${code}', ${examState}, '${subCourseCode}', '${courseGrade.course.id}', '${courseGrade.semester.schoolYear}');
    [/#list]
    addBlank("transcript${std.id}");
        function removeTr(){
            blankRow=blankRow+1;
            if(${maxRows}-blankRow>0){
                var t1=document.getElementById("transcript${std.id}");
                var maxr =${maxRows};
                for(var i=0;i<=maxr;i++){
                    if(i>blankRow){
                        t1.deleteRow(blankRow);
                    }
                }
            }
        }
     removeTr();

    </script>
  <table width='100%' border=0 valign='bottom' style="font-family:宋体;font-size:${fontsize+2}px;">
	<tr>
	<td align='left' id="TD_TC">总学分:${(gpas.get(std).credits)!}</td>
	<td align='left' id="TD_GPA">平均绩点:${(gpas.get(std).gpa)!}</td>
	<td align='left' id="TD_GP">平均分:${(gpas.get(std).ga)!}</td>
	<td align='right' >${school.name}教务处</td>
	<td align='right' width="100px" >${b.now?string('yyyy年MM月dd日')}</td>
	</tr>
	</table>
   </div>
[/#list]
</body>
</html>
[#function exchangeCourse std,course,semester]
	[#assign flag=false]
		[#if eicList??]
			[#list eicList as eic]
				[#if eic.student.id=std.id]
					[#assign cslist = eic.cslist]
					[#if cslist??]
						[#list cslist as courseSemester]
							[#if courseSemester.course.id=course.id&&courseSemester.semester.id=semester.id]
								[#assign flag=true]
							[/#if]
						[/#list]
					[/#if]
				[/#if]
			[/#list]
		[/#if]
	[#return flag]
[/#function]