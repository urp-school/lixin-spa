[#ftl]
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="content-type" content="text/html;charset=utf-8" />
  <meta http-equiv="pragma" content="no-cache"/>
  <meta http-equiv="cache-control" content="no-cache"/>
  <meta http-equiv="expires" content="0"/>
</head>
<body>
[#assign FiveLevelNames={'优':'Excellent','良':'Good','中':'Medium','及格':'Pass','不及格':'Fail'} /]

[#assign semesterFontSize=8/]
[#assign columTitleFontSize=7.5/]
[#assign contentFontSize=7.5/]

[#--计算8学期以内的成绩，每列的数目--]
[#assign semesterCount = semesterCounts.get(students?first)/]
[#assign semesters=semesterCount?keys?sort_by('beginOn')/]
[#if semesters?size < 9 ]
    [#assign maxColumn=0/]
    [#assign columLength=0/]
    [#list semesters as s]
       [#assign columLength = columLength + semesterCount.get(s)/]
       [#if s_index % 2 ==1]
        [#if columLength > maxColumn]
           [#assign maxColumn=columLength/]
        [/#if]
        [#assign columLength=0/]
       [/#if]
    [/#list]
    [#if maxColumn > 30 || maxColumn == 30 ]
        [#assign semesterFontSize=7.5/]
        [#assign columTitleFontSize=7/]
        [#assign contentFontSize=7/]
    [/#if]
[/#if]
    <style>
        body{
          font-kerning: normal;
          text-rendering: optimizeLegibility;
          font-family:Microsoft YaHei;
          font-size:${semesterFontSize}pt;
          padding:10mm 10mm 0mm 10mm;
          margin:0mm 0mm;
        }
        .semester{
            text-align:center;
            font-size:${semesterFontSize}pt;
            width:25%;
            font-family:Microsoft YaHei;
            border-top:2px #000 solid;
            border-right:2px #000 solid;
            border-left:2px #000 solid;
            border-bottom:2px #000 solid;
        }
        .blank{
            text-align:center;
            font-size:${semesterFontSize}pt;
            font-family:Microsoft YaHei;
            border-right:2px #000 solid;
            border-left:2px #000 solid;
        }
        .tds{
            text-align:center;
        }
        .tableclass{
            border-collapse:collapse;
            font-size:${contentFontSize}pt;
            border-top:2px #000 solid;
            border-right:2px #000 solid;
            border-left:2px #000 solid;
            border-bottom:2px #000 solid;
        }
        .titlecss{
            text-align:center;
            font-size:${columTitleFontSize}pt;
            width:20%;
            font-family:Microsoft YaHei;
        }
        .title{
            text-align:center;
            font-size:${columTitleFontSize}pt;
            font-family:Microsoft YaHei;
            width:50px;
        }
        .credits{
			text-align:center;
			font-size:${columTitleFontSize-0.5}pt;
			font-family:Microsoft YaHei;
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
    <div  style="min-width:255mm;padding:0px;margin:0px;[#if std_index>0]PAGE-BREAK-BEFORE: always[/#if]">
    <table  width="100%" valign='top' >
        <tr><td colspan="5" align="center"><h2 style="margin:4mm 0mm 4mm 0mm">${schoolName} &nbsp;${std.state.grade}[#if ((std.beginOn?string("MM"))!"09")=="09"](Fall) Grade[#else](Spring) Grade[/#if] Academic Achievements</h2></td></tr>
        <tr style="font-size:${contentFontSize}pt">
         <td>Education：[#if stdTypeName?contains("本科")]Undergraduate[#elseif stdTypeName?contains("专升本")]Top-up Program[#else]Junior College[/#if]</td>
         <td>&nbsp;&nbsp;[#if Minor??]Minor[#else]Major[/#if]：${std.state.major.enName!}</td>
         <td>&nbsp;Student No：${std.code}</td>
         <td>&nbsp;Name：${std.person.phoneticName!}</td>
         <td>&nbsp;Gender：${std.person.gender.enName!}</td>
        </tr>
    </table>
    <table width='100%' border="1" id="transcript${std.id}" class="tableclass">
            [#list 1..maxRows as row]
                [#--此处的tr和td中不能有空格，否则影响js中的nextSibling--]
                <tr>[#list 0..(maxCols-1) as col]<td id="transcript${std.id}_${row}_${col}" [#if (col+1)%colmns==0] style="border-right:2px #000 solid;min-width:30px" [/#if] [#if col>colmns || col=colmns][#if col%colmns==0 ] width="22%" [#else] style="min-width:30px"[/#if][#else] style="min-width:30px" [/#if]>&nbsp;</td>[/#list]</tr>
            [/#list]
    </table>
    <script>
    var index=0;
    var semesterCourses={};
    var nowsemsenumber=0;
    var blankRow=0;
    var semesterMap = {};
    var semesterList=[];
    var colmns=3;//课程，学分，成绩
    var maxRows=${maxRows}

    function SemesterBlocks(maxRows,semesterList,semesterCourses,extraCnt){
       this.semesterList=semesterList.sort();
       this.semesterCourses = semesterCourses;
       this.maxRows=maxRows;
       this.extaCnt=extraCnt;
       this.cols=[];

       function SemesterCount(id,count){
         this.id=id
         this.count=count;
       }
       function Col(idx){
          this.idx=idx;
          this.datas =[]
          this.length=0;
          this.add = function(id,count){
            this.datas.push(new SemesterCount(id,count));
            this.length += count;
          }
          this.hasCapacity=function(maxRows,needed){
            return this.length + needed <= maxRows;
          }
       }

       this.assembly = function(maxRows){
         var colIdx=0;
         var col=new Col(colIdx);
         var cols=[];
         cols.push(col);
         for(var i=0; i<this.semesterList.length;i++){
           var semester=this.semesterList[i];
           if(col.hasCapacity(maxRows,semesterCourses[semester]+extraCnt)){
             col.add(semester,this.semesterCourses[semester]+extraCnt);
           }else{
             colIdx += 1;
             col=new Col(colIdx);
             cols.push(col);
             col.add(semester,this.semesterCourses[semester]+extraCnt);
           }
         }
         return cols;
       }

       this.adjust = function(){
          if(this.semesterList.length <=8) return maxRows;
          var last=[]
          var i=maxRows;
          while(i>30){
            var cols = this.assembly(i);
            if(cols.length>4){
               if(last.length==0){
                 last=cols;
               }
               i += 1;
               break;
            }else{
               last=cols;
               i -= 1;
            }
          }
          this.cols=last;
          this.maxRows=i;
          return i;
       }
    }
    //统计学期总个数，并且去掉重复元素
    function semsernumber(n){
       if(typeof semesterMap['c'+n] == "undefined"){
         semesterList.push('c'+n);
         semesterMap['c'+n]=1;
       }
    }

    //添加学期和以下空白等说明
    function setTitle(table,row,col,value){
        var td = document.getElementById(getCellId(table,row,col));
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
        return parseInt((tdindex-parseInt(tdindex/(maxRows*colmns))*colmns*maxRows)/colmns) +1;
    }

    function calcCol(tdindex){
        return parseInt(tdindex/(maxRows*colmns))*colmns + tdindex%colmns;
    }

    function getCellId(tableId,row,col){
       return tableId+"_"+row+"_"+col;
    }
    //添加表头
    function addtitle(table){
        var row = calcRow(index);
        var col = calcCol(index);
        if(row>maxRows || col >= ${maxCols}) {
            return;
        }
        var celId=getCellId(table,row,col)
         document.getElementById(celId).className="titlecss";
         document.getElementById(celId).innerHTML="Course Name";
         document.getElementById(getCellId(table,row,col+1)).className="titlescore";
         document.getElementById(getCellId(table,row,col+1)).innerHTML="<span style='font-size:0.8em'>Credits</span>";
         document.getElementById(getCellId(table,row,col+2)).className="title";
         document.getElementById(getCellId(table,row,col+2)).innerHTML="Score";
        index+=colmns;
    }
    //添加学年学期
    function addSemester(table,semesterId,value){
        nowsemsenumber++;//当前是第几个学期
        var col = calcCol(index);
        var row = calcRow(index);
        var myCourseCnt= semesterCourses['c'+semesterId];
        if(row>maxRows || col >= ${maxCols}) {
            return;
        }
        if(semesterList.length <= 8 &&( nowsemsenumber==3 || nowsemsenumber ==5 || nowsemsenumber ==7)){
            //转到下一列的第一行
            addBlank(table);
            index=maxRows*(col+colmns);
            if(calcRow(index)>maxRows|| calcCol(index) >= ${maxCols}) {return;}
        }
        if( semesterList.length > 8 && (maxRows - row-1) < myCourseCnt){
            //转到下一列的第一行
            addBlank(table);
            index=maxRows*(col+colmns);
            if(calcRow(index)>maxRows|| calcCol(index) >= ${maxCols}) {return;}
        }
        setTitle(table,calcRow(index),calcCol(index),value);
        index+=colmns;
    }

    //添加以下空白
    function addBlank(table){
        var row = calcRow(index);
        var col = calcCol(index);
        if(row>maxRows|| col >= ${maxCols}) {return;}
        //空白行不放在第一行
        if(row==1)return;
        setTitle(table,row,col,"Blank Below");
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
        var row = calcRow(index);
        var col = calcCol(index);
        if(row>maxRows || col >= ${maxCols}) {return;}
        if(name.length>=40){
          document.getElementById(getCellId(table,row,col)).innerHTML="<font style='font-size:0.8em;'>"+name+"</font>";
        }else{
          document.getElementById(getCellId(table,row,col)).innerHTML=name;
        }
        document.getElementById(getCellId(table,row,col+1)).className="tds";
        document.getElementById(getCellId(table,row,col+2)).className="tds";
        document.getElementById(getCellId(table,row,col+1)).innerHTML=credit;
        document.getElementById(getCellId(table,row,col+2)).innerHTML=(score+"<font style='font-size:0.8em; color:red'>"+typeStr+"</font>");
        index+=colmns;
        if (blankRow <= row){
            blankRow=row + 1;
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
    var blocks=new SemesterBlocks(50,semesterList,semesterCourses,2);
    maxRows=blocks.adjust();
    [#assign semester_id=0]
    [#list grades.get(std)?sort_by(["course","code"])?sort_by(["semester","beginOn"]) as courseGrade]
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
        addScore("transcript${std.id}" ,'${courseName}','${courseGrade.course.code[0..0]}','${courseGrade.course.defaultCredits!}',
        [#if !exchangeCourse(std,courseGrade.course,courseGrade.semester)]
       		 '${FiveLevelNames[scoreText]?default(scoreText)}',
       	[#else]
       		 'Exemption',
        [/#if]
        '${courseGrade.courseTakeType.code!}', '${code}', ${examState}, '${subCourseCode}', '${courseGrade.course.id}', '${courseGrade.semester.schoolYear}');
    [/#list]
    addBlank("transcript${std.id}");

    function removeTr(maxRows){
        if(blankRow<=31){
           blankRow=31;
        }
        if(maxRows-blankRow + 1 >0){
            var t1=document.getElementById("transcript${std.id}");
            var maxr =maxRows;
            for(var i=0;i<=maxr;i++){
                if(i >= blankRow){
                    t1.deleteRow(blankRow - 1);//行号和我们文档中的行号差1
                }
            }
        }
        if(blankRow>=37){//如果空行位于37行（以1开始计算）
           document.body.style.paddingTop="3mm";
        }
    }
    removeTr(${maxRows});
    </script>
  <table width='100%' border=0 valign='bottom' style="font-size:${contentFontSize}pt;">
	<tr>
	<td align='left' id="TD_TC">Credits:${(gpas.get(std).credits)!}</td>
	<td align='left' id="TD_GPA">GPA:${(gpas.get(std).gpa)!}</td>
	<td align='left' id="TD_GP">Average Score:${(gpas.get(std).ga)!}</td>
	<td align='right' >${schoolName}</td>
	<td align='right' width="100px" >${b.now?string('MM/dd/yyyy')}</td>
	</tr>
	</table>
			[#if signature??]
			<div style="float:right;text-align: right;">
				<img src="https://xyzm.lixin.edu.cn/static/local/default/images/grade_sig.jpg" style="height:42mm;width:42mm;margin-left: 30mm;margin-top: -130px;">
			</div>
			[/#if]
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