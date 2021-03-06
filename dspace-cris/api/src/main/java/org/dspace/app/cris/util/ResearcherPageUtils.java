/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * https://github.com/CILEA/dspace-cris/wiki/License
 */
package org.dspace.app.cris.util;

import it.cilea.osd.jdyna.model.ANestedObject;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import javax.persistence.Transient;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.solr.client.solrj.util.ClientUtils;
import org.dspace.app.cris.integration.NameResearcherPage;
import org.dspace.app.cris.integration.RPAuthority;
import org.dspace.app.cris.model.ACrisObject;
import org.dspace.app.cris.model.CrisConstants;
import org.dspace.app.cris.model.ResearcherPage;
import org.dspace.app.cris.model.RestrictedField;
import org.dspace.app.cris.model.VisibilityConstants;
import org.dspace.app.cris.service.ApplicationService;
import org.dspace.content.DCPersonName;
import org.dspace.content.DSpaceObject;
import org.dspace.content.authority.Choice;
import org.dspace.content.authority.Choices;
import org.dspace.discovery.DiscoverQuery;
import org.dspace.discovery.DiscoverResult;
import org.dspace.discovery.SearchService;
import org.dspace.discovery.SearchServiceException;
import org.dspace.services.ConfigurationService;
import org.dspace.utils.DSpace;

/**
 * This class provides some static utility methods to extract information from
 * the rp identifier quering the RPs database.
 * 
 * @author cilea
 * 
 */
public class ResearcherPageUtils
{
    /** log4j logger */
    @Transient
    private static Logger log = Logger.getLogger(ResearcherPageUtils.class);
    
    /**
     * Formatter to build the rp identifier
     */
    private static DecimalFormat persIdentifierFormat = new DecimalFormat(
            "00000");

    /**
     * the applicationService to query the RP database, injected by Spring IoC
     */
    private static ApplicationService applicationService;

    /**
     * Constructor use by Spring IoC
     * 
     * @param applicationService
     *            the applicationService to query the RP database, injected by
     *            Spring IoC
     */
    public ResearcherPageUtils(ApplicationService applicationService)
    {
        ResearcherPageUtils.applicationService = applicationService;
    }

    /**
     * Build the public identifier (authority) of the supplied CRIS object
     * 
     * @param cris
     *            the cris object
     * @return the public identifier of the supplied CRIS object
     */
    public static String getPersistentIdentifier(ACrisObject cris)
    {
        return formatIdentifier(cris.getId(), cris.getClass());
    }

    
    /**
     * Build the cris identifier starting from the db internal primary key
    */
    public static <T extends ACrisObject> String getPersistentIdentifier(
            Integer crisID, Class<T> clazz)
    {
        T cris = null;
        try
        {
            cris = clazz.newInstance();
            return formatIdentifier(crisID, clazz);
        }
        catch (InstantiationException e)
        {
            log.error(e.getMessage());
        }
        catch (IllegalAccessException e)
        {
            log.error(e.getMessage());
        }
        return "";
    }
    
    
    /**
     * Format the cris suffix identifier starting from the db internal primary key
     * key
    */
    private static String formatIdentifier(Integer rp, Class className)
    {
        ACrisObject crisObject = (ACrisObject) applicationService.get(
                className, rp);
        String crisId = crisObject.getCrisID();
        if (crisId != null && !crisId.isEmpty())
        {
            return crisId;    
        }
        return crisObject.getAuthorityPrefix()
                + persIdentifierFormat.format(rp);
    }

    /**
     * Extract the db primary key from a cris identifier
     * 
     * @param authorityKey
     *            the cris identifier
     * @return the db primary key
     */
    public static Integer getRealPersistentIdentifier(String authorityKey,
            Class className)
    {
        try
        {
            String id = authorityKey.substring(2);
            ACrisObject crisObject = applicationService.getEntityByCrisId(
                    authorityKey, className);
            if (crisObject != null)
            {
                 return crisObject.getId();
            }
            return Integer.parseInt(id); 
        }
        catch (NumberFormatException e)
        {
            log.error(e.getMessage());
            return null;
        }
    }

    /**
     * Return a label to use with a specific form of the name of the researcher.
     * 
     * @param alternativeName
     *            the form of the name to use
     * @param rp
     *            the researcher page
     * @return the label to use
     */
    public static String getLabel(String alternativeName, ResearcherPage rp)
    {
        if (alternativeName.equals(rp.getFullName()))
        {
            RestrictedField translatedName = rp.getTranslatedName();
            return rp.getFullName()
                    + (translatedName != null
                            && translatedName.getValue() != null
                            && !translatedName.getValue().isEmpty()
                            && translatedName.getVisibility() == VisibilityConstants.PUBLIC ? " "
                            + translatedName.getValue()
                            : "");
        }
        else
        {
            return alternativeName + " See \"" + rp.getFullName() + "\"";
        }
    }

    /**
     * Return a label to use with a specific form of the name of the researcher.
     * 
     * @param alternativeName
     *            the form of the name to use
     * @param rpKey
     *            the rp identifier of the ResearcherPage
     * @return the label to use
     */
    public static String getLabel(String alternativeName, String rpkey)
    {
        if (rpkey != null)
        {
            ResearcherPage rp = applicationService.get(ResearcherPage.class,
                    getRealPersistentIdentifier(rpkey, ResearcherPage.class),
                    true);
            return getLabel(alternativeName, rp);
        }
        return alternativeName;
    }

    /**
     * Check if the supplied form is the fullname of the ResearcherPage
     * 
     * @param alternativeName
     *            the string to check
     * @param rpkey
     *            the rp identifier
     * @return true, if the form is the fullname of the ResearcherPage with the
     *         supplied rp identifier
     */
    public static boolean isFullName(String alternativeName, String rpkey)
    {
        if (alternativeName != null && rpkey != null)
        {
            ResearcherPage rp = applicationService.get(ResearcherPage.class,
                    getRealPersistentIdentifier(rpkey, ResearcherPage.class),
                    true);
            return alternativeName.equals(rp.getFullName());
        }
        return false;
    }

    /**
     * Check if the supplied form is the Chinese name of the ResearcherPage
     * 
     * @param alternativeName
     *            the string to check
     * @param rpkey
     *            the rp identifier
     * @return true, if the form is the Chinese name of the ResearcherPage with
     *         the supplied rp identifier
     */
    public static boolean isChineseName(String alternativeName, String rpkey)
    {
        if (alternativeName != null && rpkey != null)
        {
            ResearcherPage rp = applicationService.get(ResearcherPage.class,
                    getRealPersistentIdentifier(rpkey, ResearcherPage.class),
                    true);
            return alternativeName.equals(rp.getTranslatedName().getValue());
        }
        return false;
    }

    /**
     * Get the fullname of the ResearcherPage
     * 
     * @param rpkey
     *            the rp identifier
     * @return the fullname of the ResearcherPage
     */
    public static String getFullName(String rpkey)
    {
        if (rpkey != null)
        {
            ResearcherPage rp = applicationService.get(ResearcherPage.class,
                    getRealPersistentIdentifier(rpkey, ResearcherPage.class),
                    true);
            return rp.getFullName();
        }
        return null;
    }

    /**
     * Get the staff number of the ResearcherPage
     * 
     * @param rpkey
     *            the rp identifier
     * @return the staff number of the ResearcherPage
     */
    public static String getStaffNumber(String rpkey)
    {
        if (rpkey != null)
        {
            ResearcherPage rp = applicationService.get(ResearcherPage.class,
                    getRealPersistentIdentifier(rpkey, ResearcherPage.class),
                    true);
            return rp != null ? rp.getSourceID() : null;
        }
        return null;
    }

    /**
     * Get the rp identifier of the ResearcherPage with a given staffno
     * 
     * @param staffno
     *            the staffno
     * @return the rp identifier of the ResearcherPage or null
     */
    public static String getRPIdentifierByStaffno(String staffno)
    {
        if (staffno != null)
        {
            ResearcherPage rp = applicationService
                    .getResearcherPageByStaffNo(staffno);
            if (rp != null)
            {
                return getPersistentIdentifier(rp);
            }
        }
        return null;
    }

    /**
     * Get the ChineseName of the ResearcherPage
     * 
     * @param rpkey
     *            the rp identifier
     * @return the Chinese name of the ResearcherPage
     */
    public static String getChineseName(String rpkey)
    {
        if (rpkey != null)
        {
            ResearcherPage rp = applicationService.get(ResearcherPage.class,
                    getRealPersistentIdentifier(rpkey, ResearcherPage.class),
                    true);
            return VisibilityConstants.PUBLIC == rp.getTranslatedName()
                    .getVisibility() ? rp.getTranslatedName().getValue() : "";
        }
        return null;
    }
  
    /**
     * Get the AcademicName of the ResearcherPage
     * 
     * @param rpkey
     *            the rp identifier
     * @return the Chinese name of the ResearcherPage
     */
    public static String getAcademicName(String rpkey)
    {
        if (rpkey != null)
        {
            ResearcherPage rp = applicationService.get(ResearcherPage.class,
                    getRealPersistentIdentifier(rpkey, ResearcherPage.class),
                    true);
            return VisibilityConstants.PUBLIC == rp.getPreferredName()
                    .getVisibility() ? rp.getPreferredName().getValue() : "";
        }
        return null;
    }

    public static Integer getNestedMaxPosition(ANestedObject nested)
    {
        return applicationService.getNestedMaxPosition(nested);
    }

    public static <T extends ACrisObject> T getCrisObject(
            Integer id, Class<T> clazz)
    {
        return applicationService.get(clazz, id);
    }

    public static Choices doGetMatches(String field, String query) throws SearchServiceException
	{
    	DSpace dspace = new DSpace();
    	SearchService searchService = dspace.getServiceManager().getServiceByName(
                "org.dspace.discovery.SearchService", SearchService.class);

    	ConfigurationService configurationService = dspace.getServiceManager().getServiceByName(
                "org.dspace.services.ConfigurationService",
                ConfigurationService.class);
    	
    	return doGetMatches(field, query, configurationService, searchService);
	}
    
	public static Choices doGetMatches(String field, String query, ConfigurationService _configurationService,
			SearchService _searchService) throws SearchServiceException
	{
		Choices choicesResult;
		if (query != null && query.length() > 2)
		{
		    DCPersonName tmpPersonName = new DCPersonName(
		            query.toLowerCase());
	
		    String luceneQuery = "";
		    if (StringUtils.isNotBlank(tmpPersonName.getLastName()))
		    {
		        luceneQuery += ClientUtils.escapeQueryChars(tmpPersonName
		                .getLastName().trim())
		                + (StringUtils.isNotBlank(tmpPersonName
		                        .getFirstNames()) ? "" : "*");
		    }
	
		    if (StringUtils.isNotBlank(tmpPersonName.getFirstNames()))
		    {
		        luceneQuery += (luceneQuery.length() > 0 ? " " : "")
		                + ClientUtils.escapeQueryChars(tmpPersonName
		                        .getFirstNames().trim()) + "*";
		    }
		    luceneQuery = luceneQuery.replaceAll("\\\\ ", " ");
		    DiscoverQuery discoverQuery = new DiscoverQuery();
		    discoverQuery.setDSpaceObjectFilter(CrisConstants.RP_TYPE_ID);
		    String filter = _configurationService.getProperty("cris."
		            + RPAuthority.RP_AUTHORITY_NAME
		            + ((field != null && !field.isEmpty()) ? "." + field
		                    : "") + ".filter");
		    if (filter != null)
		    {
		        discoverQuery.addFilterQueries(filter);
		    }
	
		    discoverQuery
		            .setQuery("{!lucene q.op=AND df=crisauthoritylookup}("
		                    + luceneQuery
		                    + ") OR (\""
		                    + luceneQuery.substring(0,
		                            luceneQuery.length() - 1) + "\")");
		    discoverQuery.setMaxResults(50);
		    DiscoverResult result = _searchService.search(null,
		            discoverQuery, true);
	
			List<Choice> choiceList = new ArrayList<Choice>();
	
			for (DSpaceObject dso : result.getDspaceObjects()) {
				ResearcherPage rp = (ResearcherPage) dso;
				choiceList.add(new Choice(getPersistentIdentifier(rp), rp.getFullName(),
						getLabel(rp.getFullName(), rp)
						));
	
				if (rp.getTranslatedName() != null
						&& rp.getTranslatedName().getVisibility() == VisibilityConstants.PUBLIC
						&& rp.getTranslatedName().getValue() != null) {
					choiceList.add(new Choice(getPersistentIdentifier(rp), rp
							.getTranslatedName().getValue(),
							getLabel(rp.getTranslatedName()
									.getValue(), rp)));
				}
	
				for (RestrictedField variant : rp.getVariants()) {
					if (variant.getValue() != null
							&& variant.getVisibility() == VisibilityConstants.PUBLIC) {
						choiceList.add(new Choice(getPersistentIdentifier(rp), variant
								.getValue(), getLabel(
								variant.getValue(), rp)));
					}
				}
		    }
	
		    Choice[] results = new Choice[choiceList.size()];
		    results = choiceList.toArray(results);
		    choicesResult = new Choices(results, 0, results.length,
		            Choices.CF_AMBIGUOUS, false, 0);
		} else {
			choicesResult = new Choices(false);
		}
		return choicesResult;
	}
	
	public static List<String> getAllNamesForm(String crisID) {

        ResearcherPage rp = applicationService.getEntityByCrisId(crisID,
                ResearcherPage.class);

        if (rp == null) {
            log.error("researcher=" + crisID + " not found");
            return null;
        }

        return getAbbreviations(getAllVariantsName(null, rp));
	}
	
	
    public static List<NameResearcherPage> getAllVariantsName(
            Set<Integer> invalidIds, ResearcherPage researcher)
    {
        String authority = researcher.getCrisID();
        Integer id = researcher.getId();
        List<NameResearcherPage> names = new LinkedList<NameResearcherPage>();
        NameResearcherPage name = new NameResearcherPage(
                researcher.getFullName(), authority, id, invalidIds);
        names.add(name);
        RestrictedField field = researcher.getPreferredName();
        if (field != null && field.getValue() != null
                && !field.getValue().isEmpty())
        {
            NameResearcherPage name_1 = new NameResearcherPage(
                    field.getValue(), authority, id, invalidIds);
            names.add(name_1);
        }
        field = researcher.getTranslatedName();
        if (field != null && field.getValue() != null
                && !field.getValue().isEmpty())
        {
            NameResearcherPage name_2 = new NameResearcherPage(
                    field.getValue(), authority, id, invalidIds);
            names.add(name_2);
        }
        for (RestrictedField r : researcher.getVariants())
        {
            if (r != null && r.getValue() != null && !r.getValue().isEmpty())
            {
                NameResearcherPage name_3 = new NameResearcherPage(
                        r.getValue(), authority, id, invalidIds);
                names.add(name_3);
            }
        }

        return names;
    }
	   
    private static List<String> getAbbreviations(List<NameResearcherPage> names)
    {
        List<String> result = new ArrayList<String>();
        for (NameResearcherPage rpn : names)
        {

            String rawValue = rpn.getName();
            
            // oggetto dcpersona composto solo da cognome e nome
            DCPersonName dcpersona = new DCPersonName(rawValue);
            String firstname = "";
            //firstNames contiene una lista di iniziali del nome delle persone
            List<String> firstNames = new ArrayList<String>();
            String[] tmpStr;
            int tmp = dcpersona.getFirstNames().indexOf(" ");
            
            if(tmp > -1){
                tmpStr = dcpersona.getFirstNames().split(" ");
                for(int h = 0; h < tmpStr.length; h++){
                    if(!StringUtils.trim(tmpStr[h]).equals("")) {
                        firstname += tmpStr[h].substring(0, 1);
                        firstNames.add(firstname);
                    }
                }
                for (int h = 0; h < tmpStr.length; h++) {
                    if(!StringUtils.trim(tmpStr[h]).equals("")) {
                        firstNames.add(tmpStr[h].substring(0, 1));
                    }
                }
            }else{
                firstname = dcpersona.getFirstNames().substring(0, 1);
                firstNames.add(firstname);
            }
            
            String lastname = dcpersona.getLastName();
            result.add(dcpersona.getFirstNames() +" " + lastname);
            result.add(lastname +" " + dcpersona.getFirstNames());
            for(String first : firstNames) {
                result.add(first + " "+ lastname);
                result.add(lastname + " " + first);                
            }
            
        }
        return result;
    }
}
