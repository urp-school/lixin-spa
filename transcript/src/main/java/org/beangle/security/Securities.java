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
//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package org.beangle.security;

import java.security.Principal;
import org.beangle.security.core.context.SecurityContext;
import org.beangle.security.core.session.Session;

public final class Securities {
  public Securities() {
  }

  public static String getUsername() {
   return "171911701";
  }

  public static String getResource() {
    return SecurityContext.get().getRequest().getResource().toString();
  }

  public static String getIp() {
    return SecurityContext.get().getSession().getAgent().getIp();
  }

  public static Session getSession() {
    SecurityContext context = SecurityContext.get();
    return context.getSession();
  }

  public static Principal getPrincipal() {
    SecurityContext context = SecurityContext.get();
    Session session = context.getSession();
    return null == session ? null : session.getPrincipal();
  }

  public static boolean isRoot() {
    return SecurityContext.get().isRoot();
  }
}
