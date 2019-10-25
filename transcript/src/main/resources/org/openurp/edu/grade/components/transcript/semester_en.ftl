[#ftl]
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="content-type" content="text/html;charset=utf-8" />
  <meta http-equiv="pragma" content="no-cache"/>
  <meta http-equiv="cache-control" content="no-cache"/>
  <meta http-equiv="expires" content="0"/>
</head>
<body  style="font-size:8pt;">
[#assign FiveLevelNames={'优':'Excellent','良':'Good','中':'Medium','及格':'Pass','不及格':'Fail'} /]
    <style>
        .semester{
            text-align:center;
            font-size:8pt;
            width:25%;
            font-family:微软雅黑;
            border-top:2px #000 solid;
            border-right:2px #000 solid;
            border-left:2px #000 solid;
            border-bottom:2px #000 solid;
        }
        .blank{
            text-align:center;
            font-size:8pt;
            font-family:微软雅黑;
            border-right:2px #000 solid;
            border-left:2px #000 solid;
        }
        .tds{
            text-align:center;
        }
        .tableclass{
            border-collapse:collapse;
            font-size:7.5pt;
            border-top:2px #000 solid;
            border-right:2px #000 solid;
            border-left:2px #000 solid;
            border-bottom:2px #000 solid;
        }
        .titlecss{
            text-align:center;
            font-size:7.5pt;
            width:250px;
            font-family:微软雅黑;
        }
        .title{
            text-align:center;
            font-size:7.5pt;
            font-family:微软雅黑;
            width:50px;
        }
        .credits{
			text-align:center;
			font-size:7pt;
			font-family:微软雅黑;
			width:35px;
	    }
	</style>
    [#--最大成绩行数--]
    [#assign maxRows = 50/]
    [#assign colmns = 3/]
    [#assign maxCols = 4*colmns/]

[#list students as std]
    [#assign schoolName]${school.enName!}[/#assign]
    [#assign stdTypeName = std.level.name /]
    <div  style="width:255mm;padding:0px;margin:0px;[#if std_index>0]PAGE-BREAK-BEFORE: always[/#if]">
    <table  width="100%" valign='top' >
        <tr><td colspan="5" align="center"><h2 style="margin:4mm 0mm 4mm 0mm">${schoolName} &nbsp;${std.state.grade}[#if ((std.beginOn?string("MM"))!"09")=="09"](Fall) Grade[#else](Spring) Grade[/#if] Academic Achievements</h2></td></tr>
        <tr style="font-size:8pt">
         <td>Education：[#if stdTypeName?contains("本科")]Undergraduate[#elseif stdTypeName?contains("专升本")]Top-up Program[#else]Junior College[/#if]</td>
         <td>&nbsp;&nbsp;[#if Minor??]Minor[#else]Major[/#if]：${std.state.major.enName!}</td>
         <td>&nbsp;Student No：${std.user.code}</td>
         <td>&nbsp;Name：${std.person.phoneticName!}</td>
         <td>&nbsp;Gender：${std.person.gender.enName!}</td>
        </tr>
    </table>
    <table width='100%' border="1" id="transcript${std.id}" class="tableclass">
            [#list 1..maxRows as row]
                [#--此处的tr和td中不能有空格，否则影响js中的nextSibling--]
                <tr>[#list 0..(maxCols-1) as col]<td id="transcript${std.id}_${(col/colmns)?int*colmns*maxRows+(col%colmns)+(row-1)*colmns}" [#if (col+1)%colmns==0] style="border-right:2px #000 solid;" [/#if] [#if col>colmns || col=colmns][#if col%colmns==0 ] width="22%" [/#if][/#if]>&nbsp;</td>[/#list]</tr>
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
        document.getElementById(table+"_"+(index)).innerHTML="Course Name";
        document.getElementById(table+"_"+(index+1)).className="title";
        document.getElementById(table+"_"+(index+1)).innerHTML="<span style='font-size:0.8em'>Credits</span>";
        document.getElementById(table+"_"+(index+2)).className="title";
        document.getElementById(table+"_"+(index+2)).innerHTML="Score";
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
        setTitle(table,index,"Blank Below");
    }

    function addScore(table,name,courseTypeName,credit,score, type, code, examState, subCourseCode, courseGradeId, schoolYear){
    	var timeStr="2017-2018";
    	var codeArray=code.split("_");
        var subCourseCodeArray=subCourseCode.split("_");
        var i;
    	var typeStr="(";
    	if(schoolYear >= timeStr){
	    	if(type==3){
	    		typeStr+="Retake/";
	        }
	        if(type==5){
	        	typeStr+="Exemption/";
	        }

	        for(i=0; i<codeArray.length; i++){
	        	if(codeArray[i] == "4"){
	        		typeStr+="Make-up exam/";
	        	}else if(codeArray[i] == "6"){
	        		typeStr+="Delayed/";
	        	}
	        }
	        for(i=0; i<subCourseCodeArray.length; i++){
	        	if(subCourseCodeArray[i] == courseGradeId){
	        		typeStr+="Substitute/";
	        		break;
	        	}
	        }
	        if(examState == 1){
	        	typeStr+="Absent/";
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
        document.getElementById(table+"_"+(index+2)).innerHTML=(score+"<font style='font-size:0.8em; color:red'>"+typeStr+"</font>");
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
    [#list grades.get(std) as g]addSemesterCourse('${g.semester.id}');semsernumber('${g.semester.id}');[/#list]
    [#assign semester_id=0]
    [#list grades.get(std)?sort_by(["course","code"])?sort_by(["semester","beginOn"])  as courseGrade]
        [#if courseGrade.semester.id  != semester_id]
            [#assign semester_id=courseGrade.semester.id]
            addSemester("transcript${std.id}",'${courseGrade.semester.id}','${courseGrade.semester.schoolYear!}'+'[#if courseGrade.semester.name='1'] - 1[#elseif courseGrade.semester.name='2'] - 2[#else]${courseGrade.semester.name}[/#if]');
            addtitle("transcript${std.id}");
        [/#if]
        [#assign courseName=(courseGrade.course.enName!courseGrade.course.name)?js_string/]
        [#assign scoreText=(courseGrade.scoreText)?default("")/]
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
        [#assign subCourseCode=""]
        [#assign subCourseList=subCourseMap.get(std)]
        [#list subCourseList as subCourse]
        	[#assign subCourseCode=subCourseCode+subCourse]
        	[#if subCourse_has_next]
        		[#assign subCourseCode=subCourseCode+"_"]
        	[/#if]
        [/#list]
        addScore("transcript${std.id}" ,'${courseName}','${courseGrade.course.code[0..0]}','${courseGrade.course.credits!}',
        [#if !exchangeCourse(std,courseGrade.course,courseGrade.semester)]
       		 '${FiveLevelNames[scoreText]?default(scoreText)}',
       	[#else]
       		 'Exemption',
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
  <table width='100%' border=0 valign='bottom' style="font-family:宋体;font-size:8pt;">
	<tr>
	<td align='left' id="TD_TC">Credits:${(gpas.get(std).credits)!}</td>
	<td align='left' id="TD_GPA">GPA:${(gpas.get(std).gpa)!}</td>
	<td align='left' id="TD_GP">Average Score:${(gpas.get(std).ga)!}</td>
	<td align='right' >${schoolName}</td>
	<td align='right' width="100px" >${b.now?string('MM/dd/yyyy')}</td>
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