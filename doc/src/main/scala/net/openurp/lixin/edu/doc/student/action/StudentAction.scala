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
package net.openurp.lixin.edu.doc.student.action

import net.openurp.lixin.edu.doc.student.service.GradeConverter
import org.beangle.webmvc.api.action.ActionSupport
import org.beangle.webmvc.api.annotation.{action, param}
import org.beangle.webmvc.api.view.{Status, View}
import org.beangle.webmvc.entity.action.EntityAction
import org.openurp.base.edu.model.Student
import org.openurp.boot.edu.helper.ProjectSupport

@action("{code}")
class StudentAction extends ActionSupport with EntityAction[Student] with ProjectSupport {

  def zh(@param("code") code: String): View = {
    val stds = entityDao.findBy(classOf[Student], "user.code", List(code))
    if (stds.isEmpty) {
      Status.NotFound
    } else {
      val std = stds.head
      put("grade", GradeConverter.getGrade(std))
      put("std", std)
      forward("../zh")
    }
  }

  def en(@param("code") code: String): View = {
    val stds = entityDao.findBy(classOf[Student], "user.code", List(code))
    if (stds.isEmpty) {
      Status.NotFound
    } else {
      val std = stds.head
      put("grade", GradeConverter.getGrade(std))
      put("std", std)
      forward("../en")
    }
  }
}
