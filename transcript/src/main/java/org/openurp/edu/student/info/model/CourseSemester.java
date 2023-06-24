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
package org.openurp.edu.student.info.model;

import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import org.beangle.commons.entity.pojo.LongIdObject;
import org.openurp.base.edu.code.CourseType;
import org.openurp.base.edu.model.Course;
import org.openurp.base.edu.model.Semester;

@Entity(name="org.openurp.edu.student.info.model.CourseSemester")
public class CourseSemester
        extends LongIdObject
{
  private static final long serialVersionUID = 1846643838092077044L;
  @ManyToOne
  private Semester semester;
  @ManyToOne
  private CourseType courseType;
  @ManyToOne
  private Course course;

  public Semester getSemester()
  {
    return this.semester;
  }

  public void setSemester(Semester semester)
  {
    this.semester = semester;
  }

  public Course getCourse()
  {
    return this.course;
  }

  public void setCourse(Course course)
  {
    this.course = course;
  }

  public CourseType getCourseType()
  {
    return this.courseType;
  }

  public void setCourseType(CourseType courseType)
  {
    this.courseType = courseType;
  }
}
