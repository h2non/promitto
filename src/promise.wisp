(ns promitto.lib.
  (:require
    [promitto.lib.utils :refer [chain]]
    [promitto.lib.types :refer [states]]))

(defn ^:private then-fn
  [push dispatch]
  (fn [resolve reject notify]
    (def args arguments)
    (.for-each states (fn [name index]
      (push name (aget args index))))
    (.for-each states dispatch)))

(defn ^:private finally-fn
  [push dispatch]
  (fn [callback] 
    (push :finally callback)
    (dispatch :finally)))

(defn ^:private throw-fn
  [push dispatch]
  (fn [callback]
    (push :reject callback)
    (dispatch :reject)))

(defn ^:private notify-fn
  [state push dispatch]
  (fn [callback]
    (push :notify callback)
    (dispatch :notify)))

(defn ^:private Promise
  [ctx]
  (fn Promise [resolve reject notify]
    (.apply (.-then ctx) ctx arguments) ctx))

(defn ^:private new-promise
  [ctx]
  (let [Promise (Promise ctx)]
    (.for-each (.keys Object ctx)
      (fn [name]
        (set! (aget Promise name)
          (chain Promise 
            (aget ctx name))))) Promise))

(defn ^object promise
  "Create a new Promise"
  [state push dispatch]
  (def ctx
    { :then (then-fn push dispatch)
      :finally (finally-fn push dispatch)
      :throw (throw-fn push dispatch)
      :notify (notify-fn state push dispatch) }) (new-promise ctx))
