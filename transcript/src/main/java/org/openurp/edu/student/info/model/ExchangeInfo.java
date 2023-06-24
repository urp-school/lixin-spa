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

import java.sql.Date;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import org.beangle.commons.entity.pojo.LongIdObject;
import org.openurp.base.std.model.Student;

@Entity(name="org.openurp.edu.student.info.model.ExchangeInfo")
public class ExchangeInfo
        extends LongIdObject
{
  private static final long serialVersionUID = 8362956329015456373L;
  @ManyToOne(fetch=FetchType.LAZY)
  private Student std;
  private String externSchool;
  private String courseName;
  private String courseType;
  private Float credit;
  private Integer age;
  private Date beginOn;
  private Date endOn;
  private boolean pass;

  public boolean isPass()
  {
    return this.pass;
  }

  public Student getStd()
  {
    return this.std;
  }

  public void setStd(Student std)
  {
    this.std = std;
  }

  public String getExternSchool()
  {
    return this.externSchool;
  }

  public void setExternSchool(String externSchool)
  {
    this.externSchool = externSchool;
  }

  public String getCourseName()
  {
    return this.courseName;
  }

  public void setCourseName(String courseName)
  {
    this.courseName = courseName;
  }

  public String getCourseType()
  {
    return this.courseType;
  }

  public void setCourseType(String courseType)
  {
    this.courseType = courseType;
  }

  public Date getBeginOn()
  {
    return this.beginOn;
  }

  public void setBeginOn(Date beginOn)
  {
    this.beginOn = beginOn;
  }

  public Date getEndOn()
  {
    return this.endOn;
  }

  public void setEndOn(Date endOn)
  {
    this.endOn = endOn;
  }

  public Float getCredit()
  {
    return this.credit;
  }

  public void setCredit(Float credit)
  {
    this.credit = credit;
  }

  public void setPass(boolean pass)
  {
    this.pass = pass;
  }

  public Integer getAge()
  {
    return this.age;
  }

  public void setAge(Integer age)
  {
    this.age = age;
  }
}
