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

import java.util.HashSet;
import java.util.Set;
import javax.persistence.Entity;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import org.beangle.commons.entity.pojo.LongIdObject;
import org.openurp.edu.base.model.Course;
import org.openurp.edu.base.model.Student;

@Entity(name="org.openurp.edu.student.info.model.ExchangeInfoCourse")
public class ExchangeInfoCourse
        extends LongIdObject
{
  private static final long serialVersionUID = 4525875600003819078L;
  @ManyToOne
  private Student student;
  @ManyToMany
  private Set<Course> courses = new HashSet();
  @ManyToMany
  private Set<ExchangeInfo> info = new HashSet();
  @ManyToMany
  private Set<CourseSemester> cslist = new HashSet();

  public Set<CourseSemester> getCslist()
  {
    return this.cslist;
  }

  public void setCslist(Set<CourseSemester> cslist)
  {
    this.cslist = cslist;
  }

  public Student getStudent()
  {
    return this.student;
  }

  public void setStudent(Student student)
  {
    this.student = student;
  }

  public Set<Course> getCourses()
  {
    return this.courses;
  }

  public void setCourses(Set<Course> courses)
  {
    this.courses = courses;
  }

  public Set<ExchangeInfo> getInfo()
  {
    return this.info;
  }

  public void setInfo(Set<ExchangeInfo> info)
  {
    this.info = info;
  }
}
