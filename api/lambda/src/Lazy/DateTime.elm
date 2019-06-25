module Lazy.DateTime exposing (daily, monthly, quarterly, yearly)

import Seq exposing (Seq)
import Time.DateTime as DT exposing (DateTime)


seq : (DateTime -> DateTime) -> DateTime -> Seq DateTime
seq increment start =
    Seq.iterate increment start


daily : DateTime -> Seq DateTime
daily start =
    seq (DT.addDays 1) start


monthly : DateTime -> Seq DateTime
monthly start =
    seq (DT.addMonths 1) start


quarterly : DateTime -> Seq DateTime
quarterly start =
    seq (DT.addMonths 3) start


yearly : DateTime -> Seq DateTime
yearly start =
    seq (DT.addYears 1) start
