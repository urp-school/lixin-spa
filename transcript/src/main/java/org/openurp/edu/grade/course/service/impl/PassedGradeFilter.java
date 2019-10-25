package org.openurp.edu.grade.course.service.impl;

import org.beangle.commons.collection.CollectUtils;
import org.beangle.commons.lang.functor.Predicate;
import org.openurp.edu.grade.course.model.CourseGrade;

import java.text.SimpleDateFormat;
import java.util.List;

public class PassedGradeFilter implements GradeFilter {

  final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");

  public List<CourseGrade> filter(List<CourseGrade> grades) {
    List<CourseGrade> gradeList = CollectUtils.select(grades, new Predicate<CourseGrade>() {
      @Override
      public Boolean apply(CourseGrade grade) {
        String beginOn = sdf.format(grade.getSemester().getBeginOn());
        return Boolean.valueOf((grade.isPassed()) || beginOn.compareTo("2017-09") >= 0);
      }
    });
    return gradeList;
  }
}