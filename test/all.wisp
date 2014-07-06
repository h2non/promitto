(ns promitto.test.all
  (:require
    [chai :refer [expect]]
    [promitto.lib.collections :refer [all]]
    [promitto.lib.deferred :refer [deferred]]))

(defn ^:private random []
  (.round Math (* (.random Math) 100)))

(defn ^:private new-promise
  [reject]
  (let [defer (deferred)]
    (set-timeout
      (fn []
        (if reject
          (.reject defer 1)
          (.resolve defer 1))) (random)) (.-promise defer)))

(describe :all
  (fn []
    (describe "resolve array of promises"
      (fn []
        (let [pool [(new-promise) (new-promise) (new-promise)]
              defer (all pool)]
          (it "should resolve all the promises"
            (fn [done]
              (.then defer
                (fn [results]
                  (.to.be.an (expect results) :array)
                  (.to.have.length (expect results) 3)
                  (.to.deep.equal (expect results) [1 1 1])
                  (done)))))
          (it "should call finally state with proper data"
            (fn [done]
              (.finally defer
                (fn [results]
                  (.to.be.an (expect results) :array)
                  (.to.have.length (expect results) 3)
                  (done))))))))
    (describe "reject array of promises"
      (fn []
        (let [pool [(new-promise) (new-promise true) (new-promise)]
              defer (all pool)]
          (it "should reject the promises"
            (fn [done]
              (.catch defer
                (fn [reason]
                  (.to.be.an (expect reason) :number)
                  (.to.be.equal (expect reason) 1)
                  (done))))))))
    (describe "invalid types"
      (fn []
        (let [pool [(new-promise) nil [] (new-promise) {}]
              defer (all pool)]
          (it "should resolve the promises"
            (fn [done]
              (.then defer
                (fn [results]
                  (.to.be.an (expect results) :array)
                  (.to.have.length (expect results) 5)
                  (.to.deep.equal (expect results) [1 null null 1 null])
                  (done))))))))))
