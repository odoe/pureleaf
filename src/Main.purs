module Main where

import Debug.Trace
import Data.Foreign
import Data.Foreign.EasyFFI
import Control.Monad.Eff

foreign import data LMap :: *
foreign import data TileLayer :: *
foreign import data Mutable :: ! --need a mutable type to work with

ffi = unsafeForeignFunction

map' :: forall eff. String -> Eff (m :: Mutable | eff) LMap
map' = ffi ["s", ""] "L.map(s)"

setView :: forall eff. LMap -> [Number] -> Number -> Eff (_ :: Mutable | eff) LMap
setView = ffi ["map", "coords", "z", ""] "map.setView(coords, z)"

tileLayer :: forall eff. String -> Eff (_ :: Mutable | eff) TileLayer
tileLayer = ffi ["url", ""] "L.tileLayer(url)"

addTo :: forall eff. LMap -> TileLayer -> Eff (_ :: Mutable | eff) LMap
addTo = ffi ["map", "tileLayer", ""] "tileLayer.addTo(map)"

main = do
  tlayer <- tileLayer "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
  lmap <- map' "map"
  setView lmap [51.505, (negate 0.09)] 13
  addTo lmap tlayer
  trace $ "created leaflet map"
