(ns promitto.test.when
  (:require
    [chai :refer [expect]]
    [promitto.lib.deferred :refer [when deferred resolved]]))

(defn ^:private resolve-defer
  []
  (let [defer (deferred)]
    (set-timeout 
      (fn []
        (.resolve defer 2)) 50) (.-promise defer)))

(describe :when
  (fn []
    (it "should wrap a unresolved promise" 
      (fn [done]
        (.then (when (resolve-defer))
          (fn [data]
            (.to.be.equal (expect data) 2)
            (done)))))
    (it "should wrap a valid resolved promise" 
      (fn [done]
        (.then (when (resolved 1))
          (fn [data]
            (.to.be.equal (expect data) 1)
            (done)))))
    (it "should wrap a non-promise object as resolved" 
      (fn [done]
        (.then (when {} 1)
          (fn [data]
            (.to.be.equal (expect data) 1)
            (done))
          (fn [reason]
            (done :invalid)))))))
