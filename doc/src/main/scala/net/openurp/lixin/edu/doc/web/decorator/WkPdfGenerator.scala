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

import org.beangle.webmvc.view.ViewDecorator
import org.beangle.webmvc.api.context.ActionContext
import org.beangle.webmvc.view.ViewResult
import org.beangle.commons.lang.SystemInfo
import java.io.File
import org.beangle.commons.io.IOs
import java.io.FileOutputStream
import org.beangle.commons.lang.Charsets
import java.io.ByteArrayOutputStream
import java.io.FileInputStream
import org.beangle.commons.lang.Strings
import org.beangle.security.Securities
import org.beangle.commons.io.Files

class WkPdfGenerator extends ViewDecorator {
  override def decorate(data: ViewResult, uri: String, context: ActionContext): ViewResult = {
    val command = "C:\\Program Files\\wkhtmltopdf\\bin\\wkhtmltopdf"
    val url = context.request.getRequestURL.toString
    if (url.endsWith(".pdf")) {
      var fileName = Strings.substringAfterLast(url, "/")
      fileName = Strings.replace(fileName, ".pdf", "")
      fileName = fileName + "_" + Securities.user

      val html = new File(SystemInfo.tmpDir + Files./ + fileName + ".html")
      val target = new File(SystemInfo.tmpDir + Files./ + fileName + ".pdf")
      if (html.exists() && target.exists()) {
        val existStr = IOs.readString(new FileInputStream(html), Charsets.UTF_8)
        if (existStr.equals(data.data.toString)) {
          return deliver(target);
        }
      }
      val fos = new FileOutputStream(html)
      IOs.write(data.data.toString, fos, Charsets.UTF_8)
      IOs.close(fos)
      val pb = new ProcessBuilder(command, html.getAbsolutePath, target.getAbsolutePath)
      pb.inheritIO()
      val pro = pb.start()
      pro.waitFor()
      deliver(target)
    } else {
      data
    }
  }
  private def deliver(file: File): ViewResult = {
    val bos = new ByteArrayOutputStream
    val tin = new FileInputStream(file)
    IOs.copy(tin, bos)
    val array = bos.toByteArray
    IOs.close(bos, tin)
    new ViewResult(array, "application/pdf")
  }
}
