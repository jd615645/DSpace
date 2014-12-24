<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    https://github.com/CILEA/dspace-cris/wiki/License

--%>
<c:set var="link">${contextPath}/cris/stats/collection.html?handle=${data.object.handle}</c:set>
<c:set var="subscribeLink">${contextPath}/cris/tools/stats/subscription/subscribe?uid=${data.object.handle}&amp;type=${data.object.type}</c:set>
<c:set var="rssLink">${contextPath}/cris/stats/rss/</c:set>
<c:set var="rssImgLink">${contextPath}/image/stats/rss.png</c:set>
<c:set var="normalImgLink">${contextPath}/image/stats/stats-normal.png</c:set>
<c:set var="hotImgLink">${contextPath}/image/stats/stats-hot.png</c:set>
<c:set var="oldsubscription">
<c:if test="${dailysubscribed}">&amp;freq=1</c:if>
<c:if test="${weeklysubscribed}">&amp;freq=7</c:if>
<c:if test="${monthlysubscribed}">&amp;freq=30</c:if>
</c:set>


<li class="stats-tab<c:if test="${type ne 'item' && type ne 'bitstream'}"> stats-tab-current </c:if>">
	<a href="${link}"><fmt:message key="view.stats-collection.selectedObject.page.title" /></a>
</li>
<li class="stats-tab<c:if test="${type eq 'item'}"> stats-tab-current </c:if>">
	<a href="${link}&amp;type=item"><fmt:message key="view.stats-collection.top.item.page.title" /></a>
</li>
<li class="stats-tab<c:if test="${type eq 'bitstream'}"> stats-tab-current </c:if>"><a href="${link}&amp;type=bitstream"><fmt:message key="view.stats-collection.top.bitstream.page.title" /></a>
</li>


<li role="presentation" class="divider"></li>



<%-- title--%>
<li class="dropdown-header">
	<fmt:message key="view.stats.subscribe.statistics.label" />
</li>
<%-- content--%>
<li>
	<c:choose>
		<c:when test="${!dailysubscribed}">
			<a href="${subscribeLink}&amp;freq=1${oldsubscription}" title="Subscribe statistics email update"><img alt="Email alert" src="${normalImgLink}" /> Daily</a>
		</c:when>
		<c:otherwise>
			<a href="${subscribeLink}${fn:replace(oldsubscription,'&amp;freq=1','')}" title="Unsubscribe statistics email update"><img alt="Email alert" src="${hotImgLink}" /> Daily</a>
		</c:otherwise>
	</c:choose>
</li>
<li>
	<c:choose>
		<c:when test="${!weeklysubscribed}">
			<a href="${subscribeLink}&amp;freq=7${oldsubscription}" title="Subscribe statistics email update">
				<img alt="Email alert" src="${normalImgLink}" /> Weekly
			</a>
		</c:when>
		<c:otherwise>
			<a href="${subscribeLink}${fn:replace(oldsubscription,'&amp;freq=7','')}" title="Unsubscribe statistics email update">
				<img alt="Email alert" src="${hotImgLink}" /> Weekly
			</a>
		</c:otherwise>
	</c:choose>
</li>
<li>
	<c:choose>
		<c:when test="${!monthlysubscribed}">
			<a href="${subscribeLink}&amp;freq=30${oldsubscription}" title="Subscribe statistics email update">
				<img alt="Email alert" src="${normalImgLink}" /> Monthly
			</a>
		</c:when>
		<c:otherwise>
			<a href="${subscribeLink}${fn:replace(oldsubscription,'&amp;freq=30','')}" title="Unsubscribe statistics email update">
				<img alt="Email alert" src="${hotImgLink}" /> Monthly
			</a>
		</c:otherwise>
	</c:choose>
</li>



<li role="presentation" class="divider"></li>


<%-- title--%>
<li class="dropdown-header">
<fmt:message key="view.stats.subscribe.rss.label" />
</li>
<%-- content--%>
	<li>
			<a href="${rssLink}daily?uid=${data.object.handle}&amp;type=${data.object.type}" title="Subscribe to RSS statistics update"><img alt="RSS" src="${rssImgLink}" /> Daily</a>
	</li>
	<li>
			<a href="${rssLink}weekly?uid=${data.object.handle}&amp;type=${data.object.type}" title="Subscribe to RSS statistics update"><img alt="RSS" src="${rssImgLink}" /> Weekly</a>
	</li>
	<li>
			<a href="${rssLink}monthly?uid=${data.object.handle}&amp;type=${data.object.type}" title="Subscribe to RSS statistics update"><img alt="RSS" src="${rssImgLink}" /> Monthly</a>
	</li>
