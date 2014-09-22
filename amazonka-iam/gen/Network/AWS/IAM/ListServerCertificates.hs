{-# LANGUAGE DeriveGeneric               #-}
{-# LANGUAGE FlexibleInstances           #-}
{-# LANGUAGE NoImplicitPrelude           #-}
{-# LANGUAGE OverloadedStrings           #-}
{-# LANGUAGE RecordWildCards             #-}
{-# LANGUAGE StandaloneDeriving          #-}
{-# LANGUAGE TypeFamilies                #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Module      : Network.AWS.IAM.ListServerCertificates
-- Copyright   : (c) 2013-2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

-- | Lists the server certificates that have the specified path prefix. If none
-- exist, the action returns an empty list. You can paginate the results using
-- the MaxItems and Marker parameters. https://iam.amazonaws.com/
-- ?Action=ListServerCertificates &PathPrefix=/company/servercerts
-- &Version=2010-05-08 &AUTHPARAMS false ProdServerCert /company/servercerts/
-- arn:aws:iam::123456789012:server-certificate/company/servercerts/ProdServerCert
-- 2010-05-08T01:02:03.004Z ASCACKCEVSQ6CEXAMPLE1 2012-05-08T01:02:03.004Z
-- BetaServerCert /company/servercerts/
-- arn:aws:iam::123456789012:server-certificate/company/servercerts/BetaServerCert
-- 2010-05-08T02:03:01.004Z ASCACKCEVSQ6CEXAMPLE2 2012-05-08T02:03:01.004Z
-- TestServerCert /company/servercerts/
-- arn:aws:iam::123456789012:server-certificate/company/servercerts/TestServerCert
-- 2010-05-08T03:01:02.004Z ASCACKCEVSQ6CEXAMPLE3 2012-05-08T03:01:02.004Z
-- 7a62c49f-347e-4fc4-9331-6e8eEXAMPLE.
module Network.AWS.IAM.ListServerCertificates
    (
    -- * Request
      ListServerCertificates
    -- ** Request constructor
    , listServerCertificates
    -- ** Request lenses
    , lscPathPrefix
    , lscMarker
    , lscMaxItems

    -- * Response
    , ListServerCertificatesResponse
    -- ** Response constructor
    , listServerCertificatesResponse
    -- ** Response lenses
    , lscrServerCertificateMetadataList
    , lscrIsTruncated
    , lscrMarker
    ) where

import Network.AWS.Request.Query
import Network.AWS.IAM.Types
import Network.AWS.Prelude

data ListServerCertificates = ListServerCertificates
    { _lscPathPrefix :: Maybe Text
    , _lscMarker :: Maybe Text
    , _lscMaxItems :: Maybe Integer
    } deriving (Eq, Ord, Show, Generic)

-- | Smart constructor for the minimum required parameters to construct
-- a valid 'ListServerCertificates' request.
--
-- The fields accessible through corresponding lenses are:
--
-- * @PathPrefix ::@ @Maybe Text@
--
-- * @Marker ::@ @Maybe Text@
--
-- * @MaxItems ::@ @Maybe Integer@
--
listServerCertificates :: ListServerCertificates
listServerCertificates = ListServerCertificates
    { _lscPathPrefix = Nothing
    , _lscMarker = Nothing
    , _lscMaxItems = Nothing
    }

-- | The path prefix for filtering the results. For example:
-- /company/servercerts would get all server certificates for which the path
-- starts with /company/servercerts. This parameter is optional. If it is not
-- included, it defaults to a slash (/), listing all server certificates.
lscPathPrefix :: Lens' ListServerCertificates (Maybe Text)
lscPathPrefix = lens _lscPathPrefix (\s a -> s { _lscPathPrefix = a })

-- | Use this only when paginating results, and only in a subsequent request
-- after you've received a response where the results are truncated. Set it to
-- the value of the Marker element in the response you just received.
lscMarker :: Lens' ListServerCertificates (Maybe Text)
lscMarker = lens _lscMarker (\s a -> s { _lscMarker = a })

-- | Use this only when paginating results to indicate the maximum number of
-- server certificates you want in the response. If there are additional
-- server certificates beyond the maximum you specify, the IsTruncated
-- response element will be set to true. This parameter is optional. If you do
-- not include it, it defaults to 100.
lscMaxItems :: Lens' ListServerCertificates (Maybe Integer)
lscMaxItems = lens _lscMaxItems (\s a -> s { _lscMaxItems = a })

instance ToQuery ListServerCertificates where
    toQuery = genericQuery def

-- | Contains the result of a successful invocation of the
-- ListServerCertificates action.
data ListServerCertificatesResponse = ListServerCertificatesResponse
    { _lscrServerCertificateMetadataList :: [ServerCertificateMetadata]
    , _lscrIsTruncated :: Bool
    , _lscrMarker :: Maybe Text
    } deriving (Eq, Ord, Show, Generic)

-- | Smart constructor for the minimum required parameters to construct
-- a valid 'ListServerCertificatesResponse' response.
--
-- This constructor is provided for convenience and testing purposes.
--
-- The fields accessible through corresponding lenses are:
--
-- * @ServerCertificateMetadataList ::@ @[ServerCertificateMetadata]@
--
-- * @IsTruncated ::@ @Bool@
--
-- * @Marker ::@ @Maybe Text@
--
listServerCertificatesResponse :: [ServerCertificateMetadata] -- ^ 'lscrServerCertificateMetadataList'
                               -> Bool -- ^ 'lscrIsTruncated'
                               -> ListServerCertificatesResponse
listServerCertificatesResponse p1 p2 = ListServerCertificatesResponse
    { _lscrServerCertificateMetadataList = p1
    , _lscrIsTruncated = p2
    , _lscrMarker = Nothing
    }

-- | A list of server certificates.
lscrServerCertificateMetadataList :: Lens' ListServerCertificatesResponse [ServerCertificateMetadata]
lscrServerCertificateMetadataList =
    lens _lscrServerCertificateMetadataList
         (\s a -> s { _lscrServerCertificateMetadataList = a })

-- | A flag that indicates whether there are more server certificates to list.
-- If your results were truncated, you can make a subsequent pagination
-- request using the Marker request parameter to retrieve more server
-- certificates in the list.
lscrIsTruncated :: Lens' ListServerCertificatesResponse Bool
lscrIsTruncated = lens _lscrIsTruncated (\s a -> s { _lscrIsTruncated = a })

-- | If IsTruncated is true, this element is present and contains the value to
-- use for the Marker parameter in a subsequent pagination request.
lscrMarker :: Lens' ListServerCertificatesResponse (Maybe Text)
lscrMarker = lens _lscrMarker (\s a -> s { _lscrMarker = a })

instance FromXML ListServerCertificatesResponse where
    fromXMLOptions = xmlOptions

instance AWSRequest ListServerCertificates where
    type Sv ListServerCertificates = IAM
    type Rs ListServerCertificates = ListServerCertificatesResponse

    request = post "ListServerCertificates"
    response _ = xmlResponse

instance AWSPager ListServerCertificates where
    next rq rs
        | not (rs ^. lscrIsTruncated) = Nothing
        | otherwise = Just $
            rq & lscMarker .~ rs ^. lscrMarker
