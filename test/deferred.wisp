(ns promitto.test.deferred
  (:require
    [chai :refer [expect]]
    [promitto.lib.deferred :refer [deferred resolved rejected when]]))

(defn ^:private delay
  [lamdba]
  (set-timeout (fn [] (lamdba)) 50))

(describe "resolve promise asynchronously" 
  (fn []
    (let [defer (deferred)]
      (it "should resolve the promise" 
        (fn [done]
          (delay (fn [] 
            (.resolve defer 1)
            (done)))))
      (it "should have the resolved state and data" 
        (fn [done]
          (.then (.-promise defer)
            (fn [data]
              (.to.be.equal (expect data) 1)
              (done)))))
      (it "should call finally state with proper data" 
        (fn [done]
          (.finally (.-promise defer)
            (fn [data]
              (.to.be.equal (expect data) 1)
              (done))))))))

(describe "reject promise asynchronously" 
  (fn []
    (let [defer (deferred)]
      (it "should reject the promise" 
        (fn [done]
          (delay (fn [] 
            (.reject defer 1)
            (done)))))
      (it "should have the rejected state and data" 
        (fn [done]
          (.throw (.-promise defer)
            (fn [error]
              (.to.be.equal (expect error) 1)
              (done)))))
      (it "should call finally state with error" 
        (fn [done]
          (.finally (.-promise defer)
            (fn [data]
              (.to.be.equal (expect data) 1)
              (done))))))))
