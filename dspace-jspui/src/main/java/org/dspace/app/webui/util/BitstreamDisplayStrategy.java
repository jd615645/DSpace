/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.jstl.fmt.LocaleSupport;

import org.dspace.browse.BrowseItem;
import org.dspace.content.DCValue;
import org.dspace.content.Item;
import org.dspace.content.BitstreamFormat;
import org.dspace.content.Bitstream;
import org.dspace.core.SelfNamedPlugin;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Constants;

public class BitstreamDisplayStrategy extends SelfNamedPlugin implements
        IDisplayMetadataValueStrategy
{
    Boolean showFullBitstream;
    static
    {
        showFullBitstream = ConfigurationManager
                .getBooleanProperty("webui.browse.bitstream.showfull");
    }

    public String getMetadataDisplay(HttpServletRequest hrq,
            int limit, boolean viewFull, String browseType, int colIdx,
            String field, DCValue[] metadataArray, boolean disableCrossLinks,
            boolean emph, PageContext pageContext) throws JspException
    {
        Bitstream bs = (hrq.getAttribute("itemlist.bitstream"))[colIdx];

        if(bs != null){
            BitstreamFormat bsFormat = bs.getFormat();
            if((!bsFormat.isInternal()) || bsFormat.getMIMEType().equals("text/html"))
                LocaleSupport.getLocalizedMessage(pageContext,"itemlist.bitstream.yes");
        }

        return LocaleSupport.getLocalizedMessage(pageContext,"itemlist.bitstream.no");
    }

    public String getMetadataDisplay(HttpServletRequest hrq, int limit,
            boolean viewFull, String browseType, int colIdx, String field,
            DCValue[] metadataArray, BrowseItem item,
            boolean disableCrossLinks, boolean emph, PageContext pageContext)
            throws JspException
    {
        return getMetadataDisplay(hrq, limit, viewFull, browseType, colIdx,
                field, metadataArray, disableCrossLinks, emph, pageContext);
    }

    public String getMetadataDisplay(HttpServletRequest hrq, int limit,
            boolean viewFull, String browseType, int colIdx, String field,
            DCValue[] metadataArray, Item item, boolean disableCrossLinks,
            boolean emph, PageContext pageContext) throws JspException
    {
        if(!showFullBitstream)
            return getMetadataDisplay(hrq, limit, viewFull, browseType, colIdx,
                field, metadataArray, disableCrossLinks, emph, pageContext);
        Bitstream bs = (hrq.getAttribute("itemlist.bitstream"))[colIdx];

        if(bs == null)
            return LocaleSupport.getLocalizedMessage(pageContext,"itemlist.bitstream.no");

        String bsLink;
        String itemHandle = item.getHandle();
        BitstreamFormat bsFormat = bs.getFormat();
        Object[] bsData;

        if(bsFormat.getMIMEType().equals("text/html"))
            bsLink =
                hrq.getContextPath() + "/html/" +
                (itemHandle == null ? "db-id/" + item.getID() : itemHandle) +
                "/" + UIUtil.encodeBitstreamName(bs.getName(), Constants.DEFAULT_ENCODING);
        else if(!bsFormat.isInternal()){
            if ((itemHandle != null) && (bs.getSequenceID() > 0))
                bsLink =
                    hrq.getContextPath() + "/bitstream/" +
                    item.getHandle() + "/" + bs.getSequenceID() + "/";
            else
                bsLink = hrq.getContextPath() + "/retrieve/" + bs.getID() + "/";

            bsLink = bsLink + UIUtil.encodeBitstreamName(bs.getName(), Constants.DEFAULT_ENCODING);
        }
        else
            return LocaleSupport.getLocalizedMessage(pageContext,"itemlist.bitstream.no");

        bsData = new Object[2];
        bsData[0] = bsLink;
        bsData[1] = bs.getName();
        return LocaleSupport.getLocalizedMessage(pageContext,"itemlist.bitstream.yes.full",bsData);
    }

    public String getExtraCssDisplay(HttpServletRequest hrq, int limit,
            boolean b, String browseType, int colIdx, String field,
            DCValue[] metadataArray, boolean disableCrossLinks, boolean emph,
            PageContext pageContext) throws JspException
    {
        return null;
    }

    public String getExtraCssDisplay(HttpServletRequest hrq, int limit,
            boolean b, String browseType, int colIdx, String field,
            DCValue[] metadataArray, BrowseItem browseItem,
            boolean disableCrossLinks, boolean emph, PageContext pageContext)
            throws JspException
    {
        return getExtraCssDisplay(hrq, limit, b, browseType, colIdx, field,
                metadataArray, disableCrossLinks, emph, pageContext);
    }

    public String getExtraCssDisplay(HttpServletRequest hrq, int limit,
            boolean b, String browseType, int colIdx, String field,
            DCValue[] metadataArray, Item item, boolean disableCrossLinks,
            boolean emph, PageContext pageContext) throws JspException
    {
        return getExtraCssDisplay(hrq, limit, b, browseType, colIdx, field,
                metadataArray, disableCrossLinks, emph, pageContext);
    }

}
