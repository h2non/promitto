(ns promitto.test.promise
  (:require
    [chai :refer [expect]]
    [promitto.lib.promitto :refer [Promise]]))

(defn ^:private new-promise
  [rejected]
  (Promise.
    (fn [resolve reject]
      (set-timeout
        (fn []
          (if rejected
            (reject 2)
            (resolve 1))) 50))))

(describe :promise
  (fn []
    (it "should resolve a promise"
      (fn [done]
        (let [defer (new-promise)]
          (.then defer
            (fn [result]
              (.to.be.equal (expect result) 1)))
          (.finally defer
            (fn [result]
              (.to.be.equal (expect result) 1)
              (done))))))
    (it "should reject a promise"
      (fn [done]
        (let [defer (new-promise true)]
          (.catch defer
            (fn [reason]
              (.to.be.equal (expect reason) 2)))
          (.finally defer
            (fn [reason]
              (.to.be.equal (expect reason) 2)
              (done))))))))
