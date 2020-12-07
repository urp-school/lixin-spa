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