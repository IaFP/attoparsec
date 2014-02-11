-- |
-- Module      :  Data.Attoparsec.Internal
-- Copyright   :  Bryan O'Sullivan 2012
-- License     :  BSD3
--
-- Maintainer  :  bos@serpentine.com
-- Stability   :  experimental
-- Portability :  unknown
--
-- Simple, efficient parser combinators, loosely based on the Parsec
-- library.

module Data.Attoparsec.Internal
    (
      compareResults
    , get
    , put
    ) where

import Data.Attoparsec.Internal.Types

-- | Compare two 'IResult' values for equality.
--
-- If both 'IResult's are 'Partial', the result will be 'Nothing', as
-- they are incomplete and hence their equality cannot be known.
-- (This is why there is no 'Eq' instance for 'IResult'.)
compareResults :: (Eq t, Eq r) => IResult t r -> IResult t r -> Maybe Bool
compareResults (Fail i0 ctxs0 msg0) (Fail i1 ctxs1 msg1) =
    Just (i0 == i1 && ctxs0 == ctxs1 && msg0 == msg1)
compareResults (Done i0 r0) (Done i1 r1) =
    Just (i0 == i1 && r0 == r1)
compareResults (Partial _) (Partial _) = Nothing
compareResults _ _ = Just False

get :: Parser t t
get = Parser $ \i0 a0 m0 _kf ks -> ks i0 a0 m0 (unI i0)
{-# INLINE get #-}

put :: t -> Parser t ()
put c = Parser $ \_i0 a0 m0 _kf ks -> ks (I c) a0 m0 ()
{-# INLINE put #-}
