{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}

-- Module      : Network.AWS.Signing.Types
-- Copyright   : (c) 2013-2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Network.AWS.Signing.Types where

import Data.Time
import Network.AWS.Types
import System.Locale

data family Meta v :: *

data Signed v = Signed
    { sgHost    :: Host
    , sgRequest :: Request ()
    , sgMeta    :: Meta v
    }

class SigningAlgorithm v where
    finalise :: Service a v
             -> Request a
             -> Auth
             -> Region
             -> TimeLocale
             -> UTCTime
             -> Signed v

sign :: (AWSRequest a, AWSService (Sv a), SigningAlgorithm (Sg (Sv a)))
     => a
     -> Auth
     -> Region
     -> TimeLocale
     -> UTCTime
     -> Signed (Sg (Sv a))
sign = finalise service . request
