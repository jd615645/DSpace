/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * https://github.com/CILEA/dspace-cris/wiki/License
 */
package org.dspace.app.webui.cris.components;

import it.cilea.osd.jdyna.components.IBeanSubComponent;

public interface ICrisBeanComponent extends IBeanSubComponent
{
    String getFacetQuery();
    String getFacetField();
}
