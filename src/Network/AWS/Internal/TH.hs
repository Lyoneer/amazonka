{-# OPTIONS_GHC -fno-warn-orphans #-}

{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE QuasiQuotes       #-}

-- |
-- Module      : Network.AWS.Internal.TH
-- Copyright   : (c) 2013 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Network.AWS.Internal.TH
    (
    -- * Template Instances
      deriveTmpl
    , deriveTmpl'

    -- * QueryString Instances
    , deriveQS
    , deriveQS'

    -- * Data.Aeson.XML Instances
    , deriveXML

    -- * Data.Aeson.TH Options
    , fieldOptions
    , loweredFieldOptions
    , underscoredFieldOptions
    ) where

import           Control.Monad
import           Data.Aeson.TH
import           Data.Aeson.XML
import qualified Data.ByteString.Char8       as BS
import           Data.Monoid
import           Language.Haskell.TH
import           Language.Haskell.TH.Syntax
import           Network.AWS.Internal.String
import           Network.AWS.Internal.Types
import           Paths_aws_haskell           (getDataFileName)

deriveTmpl :: Name -> Q [Dec]
deriveTmpl name = deriveTmpl' "template/" name

deriveTmpl' :: FilePath -> Name -> Q [Dec]
deriveTmpl' path name = liftM2 (++)
    (deriveToJSON (defaultOptions { fieldLabelModifier = f }) name)
    (embedTemplate path name)
  where
    f = lowerFirst . dropLower

deriveQS :: Name -> Q [Dec]
deriveQS name = deriveQS' (lowerFirst . dropLower) name

deriveQS' :: (String -> String) -> Name -> Q [Dec]
deriveQS' f name = reify name >>= derive
  where
    derive (TyConI (DataD _ _ _ [RecC _ fields] _)) = do
        let names   = map (\(n, _, _) -> n) fields
            field n = [| queryParam s . $(global n) |]
              where
                s = BS.pack . f $ nameBase n
            query   = listE $ map field names
        [d|instance QueryString $(conT name) where
               queryString x = concatMap ($ x) $query|]

    derive (TyConI (DataD _ _ _ _ _)) = do
        [d|instance QueryString $(conT name) where
               queryString _ = []|]

    derive (TyConI (NewtypeD _ _ _ (NormalC ctor [field]) _)) = do
        [d|instance QueryString $(conT name) where
               queryString x = [(key, toBS x)]|]
      where
        key = toBS . f $ nameBase ctor

    derive err = error $ "Cannot derive QueryString instance from: " ++ show err

deriveXML :: Name -> Q [Dec]
deriveXML name = liftM2 (++)
    (deriveJSON fieldOptions name)
    ([d|instance FromXML $(conT name)|])

options, fieldOptions, loweredFieldOptions, underscoredFieldOptions :: Options
options                 = defaultOptions
fieldOptions            = options { fieldLabelModifier = dropLower }
loweredFieldOptions     = options { fieldLabelModifier = lowerAll . dropLower }
underscoredFieldOptions = options { fieldLabelModifier = underscore . dropLower }

--
-- Internal
--

instance Lift BS.ByteString where
    lift = return . LitE . StringL . BS.unpack

embedTemplate :: FilePath -> Name -> Q [Dec]
embedTemplate path name =
    [d|instance Template $(conT name) where
           readTemplate _ = $(template >>= embed)|]
  where
    template = runIO $
        getDataFileName (path <> suffix (show name)) >>= BS.readFile

    embed bstr = do
        pack <- [| BS.pack |]
        return $! AppE pack $! LitE $! StringL $! BS.unpack bstr
