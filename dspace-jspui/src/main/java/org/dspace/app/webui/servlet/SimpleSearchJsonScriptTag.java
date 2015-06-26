/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.dspace.app.webui.json.JSONRequest;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.core.PluginManager;
import org.dspace.content.*;
import org.dspace.app.webui.discovery.DiscoverUtility;
import org.dspace.app.webui.search.SearchProcessorException;
import org.dspace.discovery.SearchUtils;
import com.google.gson.Gson;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.Map;

public class SimpleSearchJsonScriptTag extends DSpaceServlet
{

    static {

        // SimpleSearchJsonScriptTag ResponseJsonSchema setting,see dspace.cfg @ 2075
        String ssjstResponseSchemaRaw = ConfigurationManager
                .getProperty("servlet.SimpleSearchJsonScriptTagResponseSchema");
        if (ssjstResponseSchemaRaw != null) {
            ssjstResponseSchemaRaw = "author:dc.contributor.author, authors:dc.contributor.*, date:dc.date, title:dc.title, titles:dc.title.*";
        }
        String[] ssjstResponseSchemaField = ssjstResponseSchemaRaw.configLine.split("\\s*,\\s*");
        String[] ssjstResponseSchemaTmp;
        String ssjstResponseSchemaName;
        String ssjstResponseSchemaQualifier;
        HashMap<String, String[]> ssjstResponseSchema = new HashMap<String, String[]>();
        for (int i = 0; i < ssjstResponseSchemaField.length; i++) {
            ssjstResponseSchemaTmp = ssjstResponseSchemaField[i].split("\\s*:\\s*");
            ssjstResponseSchemaName = ssjstResponseSchemaTmp[0];
            ssjstResponseSchemaTmp = ssjstResponseSchemaTmp[1].split("\\s*.\\s*");
            ssjstResponseSchemaQualifier = ssjstResponseSchemaTmp.length >= 3 ? ssjstResponseSchemaTmp[2] == "*" ? Item.ANY : ssjstResponseSchemaTmp[2] : null;
            ssjstResponseSchema.put(ssjstResponseSchemaName,{ssjstResponseSchemaTmp[0],ssjstResponseSchemaTmp[1],ssjstResponseSchemaQualifier});
        }

        int ssjstResponseTypeValue = Integer.valueOf(ConfigurationManager
                .getProperty("servlet.SimpleSearchJsonScriptTagResponseTypeValue"));

    }

    private static Logger log = Logger.getLogger(SimpleSearchJsonScriptTag.class);

    private class SimpleSearchJsonScriptTagResponse{
        public SimpleSearchJsonScriptTagResponse(String query,int rowslength,int start,int total,List<Item> resultsListItem){
            this.query = query;
            this.rowslength = rowslength;
            this.start = start;
            this.total = total;

            this.rows = new HashMap<String, Object>[resultsListItem.length];
            HashMap<String, Object> rowTmp;
            Item curItem;
            Iterator it;
            Map.Entry pair;
            DCValue[] metaTmp;
            String[] metaArrRes;
            Collection coll;
            Community[] comm;
            for(int i = 0; i < resultsListItem.size(); i++){
                rowTmp = new HashMap<String, Object>();
                curItem = resultsListItem.get(i);

                // columns for metadata from config
                it = ssjstResponseSchema.entrySet().iterator();
                while (it.hasNext()) {
                    pair = (Map.Entry)it.next();
                    metaTmp = curItem.getMetadata(pair.getValue()[0], pair.getValue()[1],pair.getValue()[2], Item.ANY);
                    if (metaTmp != null) {
                        if(metaTmp.length == 1){
                            rowTmp.put(pair.getKey(),metaTmp[0].value);
                        }
                        else{
                            metaArrRes = new String[metaTmp.length];
                            for (int j = 0;j < metaTmp.length; j++) {
                                metaArrRes[j] = metaTmp[j].value;
                            }
                            rowTmp.put(pair.getKey(),metaArrRes);
                        }
                    }
                    it.remove(); // avoids a ConcurrentModificationException
                }
                
                // columns to be added automatically:collhandle, collname, commhandle, commname, handle, id, summary, type
                coll = curItem.getOwningCollection();
                rowTmp.put("collhandle",coll.getHandle());
                rowTmp.put("collname",coll.getHandle());

                comm = curItem.getCommunities();
                rowTmp.put("commhandle",comm[0].getHandle());
                String commname = comm[0].getName();
                for (int j = 1;j < comm.length; j++) {
                    commname += ", " + comm[j].getName();
                }
                rowTmp.put("commname",commname);
                rowTmp.put("handle",curItem.getHandle());
                rowTmp.put("id",start + i);
                rowTmp.put("type",ssjstResponseTypeValue);

                rows[i] = rowTmp;
            }


        }
        String query;
        HashMap<String, Object>[] rows;
        int rowslength;
        int start;
        int total;
    }

    // @Override
    // protected void doDSPost(Context context, HttpServletRequest request,
    //         HttpServletResponse response) throws ServletException, IOException,
    //         SQLException, AuthorizeException
    // {
    //     doDSGet(context, request, response);
    // }

    @Override
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws IOException,
            AuthorizeException
    {
        Item[] resultsItems;
        DSpaceObject scope;
        try
        {
            scope = DiscoverUtility.getSearchScope(context, request);
        }
        catch (IllegalStateException e)
        {
            throw new SearchProcessorException(e.getMessage(), e);
        }
        catch (SQLException e)
        {
            throw new SearchProcessorException(e.getMessage(), e);
        }

        DiscoverQuery queryArgs = DiscoverUtility.getDiscoverQuery(context,
                request, scope, false);
        String query = queryArgs.getQuery();

        List<Item> resultsListItem = new ArrayList<Item>();

        // Perform the search
        DiscoverResult qResults = null;
        try
        {
            qResults = SearchUtils.getSearchService().search(context, scope, queryArgs);

            for (DSpaceObject dso : qResults.getDspaceObjects())
            {
                if (dso instanceof Item)
                {
                    resultsListItem.add((Item) dso);
                }
            }

            // resultsItems = new Item[resultsListItem.size()];
            // resultsItems = resultsListItem.toArray(resultsItems);

            // Log
            log.info(LogManager.getHeader(context, "search", "scope=" + scope
                    + ",query=\"" + query + "\",results=("
                    + resultsListItem.size()
                    + ")"));

            // JsonRoot res = new JsonRoot();
            // JsonRow rows[] = new JsonRow[resultsListItem.size()];
            // int resultStart = qResults.getStart();

            for(int i = 0; i < resultsListItem.size(); i++){
                rows[i] = new JsonRow(resultStart + i,resultsListItem.get(i));
            }

            // res.query = query;
            // res.rows = rows;
            // res.rowslength = qResults.getMaxResults();
            // res.start = resultStart;
            // res.total = qResults.getTotalSearchResults();

            response.getWriter().write((new Gson()).toJson(new SimpleSearchJsonScriptTagResponse(
                query,qResults.getMaxResults(),qResults.getStart(),qResults.getTotalSearchResults(),resultsListItem
            )));
        }
        catch (SearchServiceException e)
        {
            log.error(
                    LogManager.getHeader(context, "search", "query="
                            + queryArgs.getQuery() + ",scope=" + scope
                            + ",error=" + e.getMessage()), e);
            // request.setAttribute("search.error", true);
            // request.setAttribute("search.error.message", e.getMessage());
        }

        // JSPManager.showJSP(request, response, "/search/discovery.jsp");
    }
}
