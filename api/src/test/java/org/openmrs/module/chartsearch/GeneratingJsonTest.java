/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.chartsearch;

import net.sf.json.JSONObject;

import org.apache.solr.client.solrj.response.FacetField;
import org.apache.solr.client.solrj.response.FacetField.Count;
import org.junit.Assert;
import org.junit.Test;

public class GeneratingJsonTest {
	
	@Test
	public void generateFacetsJson_shouldreturnJSONWithNameAndCount() {
		
		Count countObject = new Count(new FacetField("TestFacetField"), "test", 34);
		
		JSONObject json = GeneratingJson.generateFacetsJson(countObject);
		
		Assert.assertNotNull(json);
		Assert.assertEquals("{\"name\":\"test\",\"count\":34}", json.toString());
	}
}
