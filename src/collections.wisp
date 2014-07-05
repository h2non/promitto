(ns promitto.lib.collections
  (:require
    [promitto.lib.utils :refer [promise?]]
    [promitto.lib.deferred :refer [deferred resolved]]))

(defn ^:private counter
  [length]
  (let [count 0]
    (fn []
      (set! count (+ count 1))
      (? (- length count) 0))))

(defn ^:private pusher
  [results]
  (fn [index data]
    (set! (aget results index) data)))

(defn ^promise all
  "Combines multiple promises into a single promise that is
  resolved when all of the input promises are resolved"
  [arr]
  (if (.is-array Array arr)
    (let [reason nil
          results []
          rejected false
          defer (deferred)
          pool (.slice arr)
          push (pusher results)
          count (counter (.-length pool))]
      (.for-each pool
        (fn [promise index]
          (if (promise? promise)
            (do
              (.then promise 
                (fn [data]
                  (cond (not rejected)
                    (push index data)))
                (fn [error]
                  (set! rejected true)
                  (set! reason error)))
              (.finally promise
                (fn []
                  (.notify defer index)
                  (cond (or (count) rejected)
                    (if rejected
                      (.reject defer reason)
                      (.resolve defer results))))))
            (do
              (count) (push index null)))))
      (.-promise defer)) (resolved)))
