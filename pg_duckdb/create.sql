-- This will be added to a future version of pg_duckdb
CREATE FUNCTION epoch_ms(duckdb.unresolved_type) RETURNS timestamp
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RAISE EXCEPTION 'SHOULD NOT ACTUALLY BE CALLED';
    END;
    $$;

create view hits as
select
    r['WatchID'] AS WatchID,
    r['JavaEnable'] AS JavaEnable,
    r['Title']::text AS Title,
    r['GoodEvent'] AS GoodEvent,
    epoch_ms(r['EventTime'] * 1000)::timestamp AS EventTime,
    (DATE '1970-01-01' + (r['EventDate'] * interval '1 day'))::date AS EventDate,
    r['CounterID'] AS CounterID,
    r['ClientIP'] AS ClientIP,
    r['RegionID'] AS RegionID,
    r['UserID'] AS UserID,
    r['CounterClass'] AS CounterClass,
    r['OS'] AS OS,
    r['UserAgent'] AS UserAgent,
    r['URL']::text AS URL,
    r['Referer']::text AS Referer,
    r['IsRefresh'] AS IsRefresh,
    r['RefererCategoryID'] AS RefererCategoryID,
    r['RefererRegionID'] AS RefererRegionID,
    r['URLCategoryID'] AS URLCategoryID,
    r['URLRegionID'] AS URLRegionID,
    r['ResolutionWidth'] AS ResolutionWidth,
    r['ResolutionHeight'] AS ResolutionHeight,
    r['ResolutionDepth'] AS ResolutionDepth,
    r['FlashMajor'] AS FlashMajor,
    r['FlashMinor'] AS FlashMinor,
    r['FlashMinor2'] AS FlashMinor2,
    r['NetMajor'] AS NetMajor,
    r['NetMinor'] AS NetMinor,
    r['UserAgentMajor'] AS UserAgentMajor,
    r['UserAgentMinor'] AS UserAgentMinor,
    r['CookieEnable'] AS CookieEnable,
    r['JavascriptEnable'] AS JavascriptEnable,
    r['IsMobile'] AS IsMobile,
    r['MobilePhone'] AS MobilePhone,
    r['MobilePhoneModel'] AS MobilePhoneModel,
    r['Params'] AS Params,
    r['IPNetworkID'] AS IPNetworkID,
    r['TraficSourceID'] AS TraficSourceID,
    r['SearchEngineID'] AS SearchEngineID,
    r['SearchPhrase'] AS SearchPhrase,
    r['AdvEngineID'] AS AdvEngineID,
    r['IsArtifical'] AS IsArtifical,
    r['WindowClientWidth'] AS WindowClientWidth,
    r['WindowClientHeight'] AS WindowClientHeight,
    r['ClientTimeZone'] AS ClientTimeZone,
    r['ClientEventTime'] AS ClientEventTime,
    r['SilverlightVersion1'] AS SilverlightVersion1,
    r['SilverlightVersion2'] AS SilverlightVersion2,
    r['SilverlightVersion3'] AS SilverlightVersion3,
    r['SilverlightVersion4'] AS SilverlightVersion4,
    r['PageCharset'] AS PageCharset,
    r['CodeVersion'] AS CodeVersion,
    r['IsLink'] AS IsLink,
    r['IsDownload'] AS IsDownload,
    r['IsNotBounce'] AS IsNotBounce,
    r['FUniqID'] AS FUniqID,
    r['OriginalURL'] AS OriginalURL,
    r['HID'] AS HID,
    r['IsOldCounter'] AS IsOldCounter,
    r['IsEvent'] AS IsEvent,
    r['IsParameter'] AS IsParameter,
    r['DontCountHits'] AS DontCountHits,
    r['WithHash'] AS WithHash,
    r['HitColor'] AS HitColor,
    r['LocalEventTime'] AS LocalEventTime,
    r['Age'] AS Age,
    r['Sex'] AS Sex,
    r['Income'] AS Income,
    r['Interests'] AS Interests,
    r['Robotness'] AS Robotness,
    r['RemoteIP'] AS RemoteIP,
    r['WindowName'] AS WindowName,
    r['OpenerName'] AS OpenerName,
    r['HistoryLength'] AS HistoryLength,
    r['BrowserLanguage'] AS BrowserLanguage,
    r['BrowserCountry'] AS BrowserCountry,
    r['SocialNetwork'] AS SocialNetwork,
    r['SocialAction'] AS SocialAction,
    r['HTTPError'] AS HTTPError,
    r['SendTiming'] AS SendTiming,
    r['DNSTiming'] AS DNSTiming,
    r['ConnectTiming'] AS ConnectTiming,
    r['ResponseStartTiming'] AS ResponseStartTiming,
    r['ResponseEndTiming'] AS ResponseEndTiming,
    r['FetchTiming'] AS FetchTiming,
    r['SocialSourceNetworkID'] AS SocialSourceNetworkID,
    r['SocialSourcePage'] AS SocialSourcePage,
    r['ParamPrice'] AS ParamPrice,
    r['ParamOrderID'] AS ParamOrderID,
    r['ParamCurrency'] AS ParamCurrency,
    r['ParamCurrencyID'] AS ParamCurrencyID,
    r['OpenstatServiceName'] AS OpenstatServiceName,
    r['OpenstatCampaignID'] AS OpenstatCampaignID,
    r['OpenstatAdID'] AS OpenstatAdID,
    r['OpenstatSourceID'] AS OpenstatSourceID,
    r['UTMSource'] AS UTMSource,
    r['UTMMedium'] AS UTMMedium,
    r['UTMCampaign'] AS UTMCampaign,
    r['UTMContent'] AS UTMContent,
    r['UTMTerm'] AS UTMTerm,
    r['FromTag'] AS FromTag,
    r['HasGCLID'] AS HasGCLID,
    r['RefererHash'] AS RefererHash,
    r['URLHash'] AS URLHash,
    r['CLID'] AS CLID
from read_parquet('/tmp/hits.parquet', binary_as_string => true) r;
