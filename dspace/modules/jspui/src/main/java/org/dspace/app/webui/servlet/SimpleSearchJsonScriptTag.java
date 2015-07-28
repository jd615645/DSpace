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
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.dspace.app.webui.json.JSONRequest;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.core.PluginManager;
import org.dspace.core.ConfigurationManager;
import org.dspace.content.*;
import org.dspace.app.webui.discovery.DiscoverUtility;
import org.dspace.app.webui.search.SearchProcessorException;
import org.dspace.discovery.*;
import com.google.gson.Gson;
import java.util.*;

public class SimpleSearchJsonScriptTag extends DSpaceServlet
{
    private static HashMap<String, String[]> ssjstResponseSchema;
    private static int ssjstResponseTypeValue;
    private static String ssjsResponseCallbackName;
    public final static String concatArr = "+";

    static {

        // SimpleSearchJsonScriptTag ResponseJsonSchema setting,see dspace.cfg @ 2075
        String ssjstResponseSchemaRaw = ConfigurationManager
                .getProperty("SimpleSearchJsonScriptTag.ResponseSchema");
        if (ssjstResponseSchemaRaw == null) {
            ssjstResponseSchemaRaw = "author:dc.contributor.+, authors:dc.contributor.*, date:dc.date, title:dc.title, titles:dc.title.*, summary:dc.description.+";
        }
        String[] ssjstResponseSchemaField = ssjstResponseSchemaRaw.split("\\s*,\\s*");
        String[] ssjstResponseSchemaTmp;
        String ssjstResponseSchemaName;
        String ssjstResponseSchemaQualifier;
        String[] ssjstResponseSchemaStrTmp; 
        ssjstResponseSchema = new HashMap<String, String[]>();
        for (int i = 0; i < ssjstResponseSchemaField.length; i++) {
            ssjstResponseSchemaStrTmp = new String[4];
            ssjstResponseSchemaTmp = ssjstResponseSchemaField[i].split("\\s*:\\s*");
            ssjstResponseSchemaName = ssjstResponseSchemaTmp[0];
            ssjstResponseSchemaTmp = ssjstResponseSchemaTmp[1].split("\\s*\\.\\s*");
            ssjstResponseSchemaQualifier = ssjstResponseSchemaTmp.length >= 3 ? ssjstResponseSchemaTmp[2].equals("*") || ssjstResponseSchemaTmp[2].equals(concatArr) ? Item.ANY : ssjstResponseSchemaTmp[2] : null;
            ssjstResponseSchemaStrTmp[0] = ssjstResponseSchemaTmp[0];
            ssjstResponseSchemaStrTmp[1] = ssjstResponseSchemaTmp[1];
            ssjstResponseSchemaStrTmp[2] = ssjstResponseSchemaQualifier;
            ssjstResponseSchemaStrTmp[3] = ssjstResponseSchemaQualifier != null ? ssjstResponseSchemaTmp[2].equals(concatArr) ? concatArr : "" : "";
            ssjstResponseSchema.put(ssjstResponseSchemaName,ssjstResponseSchemaStrTmp);
        }

        ssjstResponseTypeValue = ConfigurationManager
                .getIntProperty("SimpleSearchJsonScriptTag.ResponseTypeValue",2);

        ssjsResponseCallbackName = ConfigurationManager
                .getProperty("SimpleSearchJsonScriptTag.ResponseCallbackName");
        if (ssjsResponseCallbackName == null) {
            ssjsResponseCallbackName = "stcCallback1111";
        }
    }

    private class SimpleSearchJsonScriptTagResponse{
        public SimpleSearchJsonScriptTagResponse(String query,int rowslength,int start,int total,List<Item> resultsListItem) 
        throws SQLException {
            this.query = query;
            this.rowslength = rowslength;
            this.start = start;
            this.total = total;

            this.rows = new ArrayList<HashMap<String, Object>>();
            HashMap<String, Object> rowTmp;
            Item curItem;
            DCValue[] metaTmp;
            String[] metaArrRes;
            org.dspace.content.Collection coll;
            Community[] comm;
            String[] metaStrArrTmp;
            for(int i = 0; i < resultsListItem.size(); i++){
                rowTmp = new HashMap<String, Object>();
                curItem = resultsListItem.get(i);

                // columns for metadata from config
                for (Map.Entry<String, String[]> pair : ssjstResponseSchema.entrySet()){
                    metaStrArrTmp = pair.getValue();
                    metaTmp = curItem.getMetadata(metaStrArrTmp[0], metaStrArrTmp[1],metaStrArrTmp[2], Item.ANY);
                    if (metaTmp != null) {
                        if(metaTmp.length <= 1 && metaStrArrTmp[2] != Item.ANY){
                            rowTmp.put(pair.getKey(),metaTmp.length == 0 ? null : metaTmp[0].value);
                        }
                        else if(metaStrArrTmp[3].equals(concatArr)){
                            metaArrRes = new String[1];
                            metaArrRes[0] = metaTmp.length == 0 ? "" : metaTmp[0].value;
                            for (int j = 1; j < metaTmp.length; j++) {
                                metaArrRes[0] += ", " + metaTmp[j].value;
                            }
                            rowTmp.put(pair.getKey(),metaArrRes[0]);
                        }
                        else {
                            metaArrRes = new String[metaTmp.length];
                            for (int j = 0; j < metaTmp.length; j++) {
                                metaArrRes[j] = metaTmp[j].value;
                            }
                            rowTmp.put(pair.getKey(),metaArrRes);
                        }
                    }
                    /* else { */
                    /*     rowTmp.put(pair.getKey(),null); */
                    /* } */
                }
                
                // columns to be added automatically:collhandle, collname, commhandle, commname, handle, id, type
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

                rows.add(rowTmp);
            }


        }
        String query;
        List<HashMap<String, Object>> rows;
        int rowslength;
        int start;
        int total;
    }

    private static Logger log = Logger.getLogger(SimpleSearchJsonScriptTag.class);

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
        catch (Exception e)
        {
            log.error(
                LogManager.getHeader(context, "search_prepare", "error=" + e.getMessage()), e);
            throw new IOException(e.getMessage());
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

            // Log
            log.info(LogManager.getHeader(context, "search", "scope=" + scope
                    + ",query=\"" + query + "\",results=("
                    + resultsListItem.size()
                    + ")"));

            response.setContentType("text/javascript");
            response.setCharacterEncoding("UTF-8");
            PrintWriter writer = response.getWriter();
            writer.write(ssjsResponseCallbackName + "(");
            writer.write((new Gson()).toJson(new SimpleSearchJsonScriptTagResponse(
                query,qResults.getMaxResults(),qResults.getStart(),(int) qResults.getTotalSearchResults(),resultsListItem
            )));
            writer.write(")");
        }
        catch (Exception e)
        {
            log.error(
                    LogManager.getHeader(context, "search", "query="
                            + queryArgs.getQuery() + ",scope=" + scope
                            + ",error=" + e.getMessage()), e);
            throw new IOException(e.getMessage());
        }
    }
}

