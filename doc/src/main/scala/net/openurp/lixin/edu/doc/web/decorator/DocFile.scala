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
package net.openurp.lixin.edu.doc.web.decorator

import org.beangle.commons.lang.Strings
import org.beangle.commons.io.Files
import org.beangle.commons.lang.SystemInfo
import java.io.File
import org.beangle.security.Securities

object DocFile {
  private def fileName(path: String): String = {
    var fileName =
      if (path.contains("/")) {
        Strings.substringAfterLast(path, "/")
      } else {
        path
      }
    fileName = Strings.replace(fileName, ".pdf", "")
    fileName + "_" + Securities.user
  }

  def html(path: String): File = {
    new File(SystemInfo.tmpDir + Files./ + fileName(path) + ".html")
  }

  def pdf(path: String): File = {
    new File(SystemInfo.tmpDir + Files./ + fileName(path) + ".pdf")
  }

}
