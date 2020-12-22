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
package net.openurp.lixin.edu.doc.certification.action

import net.openurp.lixin.edu.doc.certification.service.GradeConverter
import org.beangle.webmvc.api.action.ActionSupport
import org.beangle.webmvc.api.view.View
import org.beangle.webmvc.entity.action.EntityAction
import org.openurp.edu.base.model.Student
import org.openurp.edu.web.ProjectSupport
import org.openurp.std.info.model.Graduation

/**
 * 学位证书翻译
 */
class DegreeAction extends ActionSupport with EntityAction[Graduation] with ProjectSupport {

	def index(): View = {
		val std = getUser(classOf[Student])
		val graduations = entityDao.findBy(classOf[Graduation], "std", List(std))
		put("std", std)
		graduations.foreach(graduation=>{
			put("graduation", graduation)
		})
		forward()
	}

}
