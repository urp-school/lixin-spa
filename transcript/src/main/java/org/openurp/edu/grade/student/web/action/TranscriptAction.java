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
package org.openurp.edu.grade.student.web.action;

import com.google.gson.Gson;
import org.beangle.commons.collection.CollectUtils;
import org.beangle.commons.dao.query.builder.OqlBuilder;
import org.beangle.commons.lang.Strings;
import org.beangle.security.Securities;
import org.openurp.base.std.model.Student;
import org.openurp.code.edu.model.CourseTakeType;
import org.openurp.code.edu.model.GradeType;
import org.openurp.base.edu.model.Course;
import org.openurp.base.edu.model.Project;
import org.openurp.base.edu.model.Semester;
import org.openurp.edu.grade.app.service.TranscriptTemplateService;
import org.openurp.edu.grade.config.TranscriptTemplate;
import org.openurp.edu.grade.course.model.CourseGrade;
import org.openurp.edu.grade.transcript.service.TranscriptDataProvider;
import org.openurp.edu.grade.transcript.service.impl.SpringTranscriptDataProviderRegistry;
import org.openurp.edu.grade.transcript.service.impl.TranscriptPublishedGradeProvider;
import org.openurp.edu.student.info.model.CourseSemester;
import org.openurp.edu.student.info.model.ExchangeInfoCourse;
import org.openurp.edu.web.action.BaseAction;

import java.util.*;

/**
 * 学生打印自己的成绩单总表
 */
public class TranscriptAction extends BaseAction {

	private TranscriptTemplateService transcriptTemplateService;

	private SpringTranscriptDataProviderRegistry dataProviderRegistry;

	@SuppressWarnings("unchecked")
	public String report() throws Exception {
		Student me = getLoginStudent();
		Date now = new Date(System.currentTimeMillis());
		List<Student> students = Collections.singletonList(me);
		TranscriptTemplate template = null;
		String templateName = get("template");
		if (null != templateName) template = transcriptTemplateService.getTemplate(me.getProject(), templateName);
		Map<String, String> options = CollectUtils.newHashMap();
		if (null != template) options = new Gson().fromJson(template.getOptions(), Map.class);
		if (null == options) options = CollectUtils.newHashMap();
		for (TranscriptDataProvider provider : dataProviderRegistry.getProviders(options.get("providers"))) {
			put(provider.getDataName(), provider.getDatas(students, options));
		}
		put("date", now);
		put("school", me.getProject().getSchool());
		put("students", students);
		put("RESTUDY", CourseTakeType.Repeat);
		put("GA", entityDao.get(GradeType.class, GradeType.GA_ID));
		if (null == template) return forward();
		else {
			String templatePath = template.getTemplate();
			if (templatePath.startsWith("freemarker:"))
				templatePath = templatePath.substring("freemarker:".length());
			if (templatePath.endsWith(".ftl")) templatePath = Strings.substringBeforeLast(templatePath, ".ftl");
			return forward(templatePath);
		}
	}

	public String index() throws Exception {
		Student me = getLoginStudent();
		TranscriptTemplate template = null;
		String templateName = get("template");
		if (null != templateName) {
			template = this.transcriptTemplateService.getTemplate(me.getProject(), templateName);
		}
		Map<String, String> options = CollectUtils.newHashMap();
		if (null != template) {
			options = (Map) new Gson().fromJson(template.getOptions(), Map.class);
		}
		if (null == options) {
			options = CollectUtils.newHashMap();
		}
		List<Student> students = Collections.singletonList(me);
		OqlBuilder<ExchangeInfoCourse> builder = OqlBuilder.from(ExchangeInfoCourse.class, "eic");
		builder.where("eic.student=:me", me);
		List<ExchangeInfoCourse> eicList = this.entityDao.search(builder);
		for (TranscriptDataProvider provider : this.dataProviderRegistry.getProviders((String) options.get("providers"))) {
			if (provider.getDataName().equals("grades")) {
				Map<Student, List<Long>> subCourseMap = CollectUtils.newHashMap();
				if ((provider instanceof TranscriptPublishedGradeProvider)) {
					Map<Student, List<CourseGrade>> stdGradeMaps = ((TranscriptPublishedGradeProvider) provider).getDatas(students, options, subCourseMap);
					for (ExchangeInfoCourse info : eicList) {
						List<CourseGrade> cgs = (List) stdGradeMaps.get(info.getStudent());
						Set<CourseSemester> cslist = info.getCslist();
						for (CourseSemester cs : cslist) {
							Course course = cs.getCourse();
							boolean flag = true;
							for (CourseGrade courseGrade : cgs) {
								if (((Long) courseGrade.getCourse().getId()).longValue() == ((Long) course.getId()).longValue()) {
									flag = false;
									break;
								}
							}
							if (flag) {
								CourseGrade grade = new CourseGrade();
								grade.setCourse(course);
								grade.setSemester(cs.getSemester());
								grade.setStd(info.getStudent());
								grade.setScoreText("免修");
								grade.setScore(null);
								grade.setGp(null);
								grade.setCourseTakeType(codeService.getCode(CourseTakeType.class, Integer.valueOf(5)));
								cgs.add(grade);
							}
						}
					}

					Map<Student, Map<Semester, Integer>> semesterCounts = CollectUtils.newHashMap();
					for (Map.Entry<Student, List<CourseGrade>> entry : stdGradeMaps.entrySet()) {
						Map<Semester, Integer> semesterCount = CollectUtils.newHashMap();
						semesterCounts.put(entry.getKey(), semesterCount);
						for (CourseGrade g : entry.getValue()) {
							semesterCount.compute(g.getSemester(), (s, o) -> {
								return (o == null) ? 1 : o.intValue() + 1;
							});
						}
					}
					put("semesterCounts", semesterCounts);
					put("grades", stdGradeMaps);
					put("subCourseMap", subCourseMap);
				}
			} else {
				put(provider.getDataName(), provider.getDatas(students, options));
			}
		}
		put("eicList", eicList);

		put("date", new Date(System.currentTimeMillis()));
		put("RESTUDY", Integer.valueOf(3));
		put("school", me.getProject().getSchool());
		put("students", students);
		put("GA", new GradeType(GradeType.GA_ID));
		put("MAKEUP_GA", new GradeType(GradeType.MAKEUP_GA_ID));
		put("printFlag", Boolean.valueOf(true));
		String format = get("format");
		Project project = me.getProject();
		if ("立信会计金融辅修".equals(project.getName())) {
			put("Minor", "1");
		}

		if (null == template) {
			return forward();
		}
		String path = template.getTemplate();
		if (path.startsWith("freemarker:")) {
			path = path.substring("freemarker:".length());
		}
		if (path.endsWith(".ftl")) {
			path = Strings.substringBeforeLast(path, ".ftl");
		}
		String signature = get("signature");
		if (null != signature) {
			put("signature", signature);
		}
		return forward(path);
	}

	private Student getLoginStudent() {
		OqlBuilder<Student> builder =
			OqlBuilder.from(Student.class, "std").where("std.code = :code", Securities.getUsername());
		builder.where("std.project.id=5");
		builder.where("std.project.minor=false");
		List<Student> students = entityDao.search(builder);
		if (students.isEmpty()) return null;
		else return students.get(0);
	}

	public void setTranscriptTemplateService(TranscriptTemplateService transcriptTemplateService) {
		this.transcriptTemplateService = transcriptTemplateService;
	}

	public void setDataProviderRegistry(SpringTranscriptDataProviderRegistry dataProviderRegistry) {
		this.dataProviderRegistry = dataProviderRegistry;
	}

}
