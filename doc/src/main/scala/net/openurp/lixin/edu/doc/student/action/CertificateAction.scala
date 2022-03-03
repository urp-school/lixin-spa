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
import org.beangle.webmvc.api.view.View
import org.beangle.webmvc.entity.action.EntityAction
import org.openurp.base.edu.model.Student
import org.openurp.boot.edu.helper.ProjectSupport

class CertificateAction extends ActionSupport with EntityAction[Student] with ProjectSupport {

  def zh(): View = {
    val std = getUser(classOf[Student])
    put("std", std)
    forward()
  }

  def en(): View = {
    val std = getUser(classOf[Student])
    put("grade", GradeConverter.getGrade(std))
    put("std", std)
    forward()
  }

}
