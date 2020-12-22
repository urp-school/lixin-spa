/*
 * OpenURP, Agile University Resource Planning Solution.
 *
 * Copyright © 2014, The OpenURP Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful.
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.openurp.edu.grade.course.service.impl;

import org.beangle.commons.collection.CollectUtils;
import org.openurp.base.edu.model.Course;
import org.openurp.edu.grade.course.model.CourseGrade;
import org.openurp.edu.program.model.AlternativeCourse;
import org.openurp.edu.program.plan.service.AlternativeCourseService;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class BestGradeFilter implements GradeFilter {
  private AlternativeCourseService alternativeCourseService;

  public BestGradeFilter() {
  }

  protected Map<Course, CourseGrade> buildGradeMap(List<CourseGrade> grades, List<CourseGrade> returnGrades) {
    Map<Course, CourseGrade> gradesMap = CollectUtils.newHashMap();
    CourseGrade old = null;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    for (CourseGrade grade : grades) {
      old = (CourseGrade) gradesMap.get(grade.getCourse());
      Date endOn = grade.getSemester().getEndOn();
      try {
        Date date = sdf.parse("2017-09-01");
        if (endOn.after(date)) {
          returnGrades.add(grade);
        } else if (GradeComparator.betterThan(grade, old)) {
          gradesMap.put(grade.getCourse(), grade);
        }
      } catch (ParseException e) {
        e.printStackTrace();
      }
    }
    return gradesMap;
  }


  /**
   * @param grades <SubstitueCourse>
   * @return
   */

  public List<CourseGrade> filter(List<CourseGrade> grades) {
    List<CourseGrade> returnGrades = CollectUtils.newArrayList();
    Map<Course, CourseGrade> gradesMap = buildGradeMap(grades, returnGrades);
    List<AlternativeCourse> substituteCourses = getSubstituteCourses(grades);
    for (AlternativeCourse subCourse : substituteCourses) {
      if (GradeComparator.isSubstitute(subCourse, gradesMap)) {
        for (Course c : subCourse.getOlds()) {
          gradesMap.remove(c);
        }
      }
    }
    Object newArrayList = CollectUtils.newArrayList(gradesMap.values());
    returnGrades.addAll((Collection) newArrayList);
    return returnGrades;
  }

  private List<AlternativeCourse> getSubstituteCourses(List<CourseGrade> grades) {
    if (grades.isEmpty()) {
      return Collections.emptyList();
    }
    CourseGrade grade = grades.get(0);
    return alternativeCourseService.getAlternativeCourses(grade.getStd());
  }

  public final void setAlternativeCourseService(AlternativeCourseService alternativeCourseService) {
    this.alternativeCourseService = alternativeCourseService;
  }

  public List<CourseGrade> filter(List<CourseGrade> grades, List<Long> subCourseGradeIds) {
    List<CourseGrade> returnGrades = CollectUtils.newArrayList();
    Map<Course, CourseGrade> gradesMap = buildGradeMap(grades, returnGrades);
    List<AlternativeCourse> substituteCourses = getSubstituteCourses(grades);
    for (AlternativeCourse subCourse : substituteCourses) {
      if (GradeComparator.isSubstitute(subCourse, gradesMap)) {
        boolean isExist = false;
        for (Course c : subCourse.getOlds()) {
          if (gradesMap.containsKey(c)) {
            isExist = true;
          }
          gradesMap.remove(c);
        }
        if (isExist) {
          for (Course c : subCourse.getNews()) {
            subCourseGradeIds.add(c.getId());
          }
        }
      }
    }
    Object newArrayList = CollectUtils.newArrayList(gradesMap.values());
    returnGrades.addAll((Collection) newArrayList);
    return returnGrades;
  }


}
