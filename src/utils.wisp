(ns promitto.lib.utils)

(defn ^boolean fn?
  "Check if the given object is a function type"
  [o]
  (identical? (typeof o) :function))

(defn ^array ->arr
  "Convert arguments object into array"
  [o]
  (.call (.-slice (.-prototype Array)) o))

(defn ^boolean promise? 
  "Check if then given is a promise"
  [o]
  (and (fn? o) (fn? (.-then o))))

(defn ^number next-tick
  "Make function execution asynchronous"
  [lamdba]
  (set-timeout lamdba 0))

(defn ^fn chain
  [obj fn]
  (fn []
    (apply fn arguments) obj))