(ns promitto.lib.index
  (:require
    [promitto.lib.utils :refer [promise? fn?]]
    [promitto.lib.collections :refer [all]]
    [promitto.lib.deferred :refer [deferred resolved rejected when]]))

(defn ^:private Promitto
  [lamdba]
  (let [defer (deferred)]
    (cond (not (fn? lamdba))
      (throw (TypeError. "first argument must be a function")))
    (lamdba
      (.-resolve defer)
      (.-reject defer) 
      (.-notify defer)) (.-promise defer)))

(set! (.-Promise Promitto) Promitto)
(set! (.-defer Promitto) deferred)
(set! (.-when Promitto) when)
(set! (.-resolve Promitto) resolved)
(set! (.-reject Promitto) rejected)
(set! (.-all Promitto) all)
(set! (.-promise? Promitto) promise?)
(set! (.-exports module) Promitto)
