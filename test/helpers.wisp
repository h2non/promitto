(ns promitto.test.helpers
  (:require
    [chai :refer [expect]]
    [promitto.lib.promitto :refer [promise? resolve defer Promise]]))

(describe :isPromise
  (fn []
    (it "should be a promise" 
      (fn []
        (.-to.be.true (expect (promise? (resolve))))
        (.-to.be.true (expect (promise? (.-promise (defer)))))
        (.-to.be.true (expect (promise? (Promise (fn [])))))))
    (it "should not be a promise" 
      (fn []
        (.-to.be.false (expect (promise? {})))
        (.-to.be.false (expect (promise? [])))
        (.-to.be.false (expect (promise? (fn []))))
        (.-to.be.false (expect (promise? nil)))
        (.-to.be.false (expect (promise? "")))
        (.-to.be.false (expect (promise? null)))))))