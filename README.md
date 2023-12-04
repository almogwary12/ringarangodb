# ringodb

ring library to connect with arangodb server


in ringcurl added the following code

<code>
RING_FUNC(ring_curl_getStatusCode){
	CURLcode res;
	CURL *pCurl;

	if ( RING_API_PARACOUNT != 1 ) {
		RING_API_ERROR(RING_API_MISS1PARA);
		return ;
	}
	RING_API_IGNORECPOINTERTYPE ;
	if ( ! RING_API_ISPOINTER(1) ) {
		RING_API_ERROR(RING_API_BADPARATYPE);
		return ;
	}
	pCurl = (CURL *) RING_API_GETCPOINTER(1,"CURL") ;
	long response_code;
	curl_easy_getinfo(pCurl, CURLINFO_RESPONSE_CODE, &response_code);
	RING_API_RETNUMBER(response_code);

}

RING_FUNC(ring_curl_getContentType){
	CURL *pCurl;

	if ( RING_API_PARACOUNT != 1 ) {
		RING_API_ERROR(RING_API_MISS1PARA);
		return ;
	}
	RING_API_IGNORECPOINTERTYPE ;
	if ( ! RING_API_ISPOINTER(1) ) {
		RING_API_ERROR(RING_API_BADPARATYPE);
		return ;
	}
	pCurl = (CURL *) RING_API_GETCPOINTER(1,"CURL") ;
	char *ct = NULL;
	curl_easy_getinfo(pCurl, CURLINFO_CONTENT_TYPE, &ct);
	RING_API_RETSTRING(ct);

}

</code>

<register>
long curl_getStatusCode(CURL * easy_handle)
char * curl_getContentType( CURL * easy_handle)
</register>
