(ns promitto.lib.deferred
  (:require
    [promitto.lib.utils :refer [fn? ->arr promise? next-tick chain]]
    [promitto.lib.types :refer [states new-state new-pool new-buf]]
    [promitto.lib.promise :refer [promise]]))

(defn ^:private pusher
  [pool]
  (fn [type fn]
    (cond (fn? fn)
      (.push (aget pool type) fn))))

(defn ^:private switch-state
  [state]
  (fn [type]
    (cond 
      (and (not (? type :notify)) (.-pending state))
      (do
        (set! (.-pending state) false)
        (cond (? type :resolve) 
          (set! (.-resolve state) true))
        (cond (? type :reject)
          (set! (.-reject state) true))))))

(defn ^:private cache-args
  [buf]
  (fn [type args]
    (set! (aget buf type) (->arr args))))

(defn ^:private buf-args
  [state buf]
  (fn [type fn]
      (if (? type :finally)
        (if (.-reject state)
          (.-reject buf)
          (.-resolve buf))
        (aget buf type))))

(defn ^:private dispatcher
  [state buf]
  (let [get-args (buf-args state buf)]
    (fn [type]
      (fn [fn]
        (cond (fn? fn)
          (let [args (get-args type fn)]
            (apply fn args)))))))

(defn ^:private dispatch
  [state pool buf]
  (let [dispatcher (dispatcher state buf)]
    (fn [type]
      (next-tick 
        (fn []
          (cond (or (aget state type) (? type :notify))
            (do
              (.for-each (aget pool type) 
                (dispatcher type))
              (cond (not (? type :notify))
                (.splice (aget pool type) 0))))
          (cond (and
                  (not (.-pending state))
                  (.-length (aget pool :finally)))
            (do
              (.for-each (.-finally pool) (dispatcher :finally))
              (.splice (.-finally pool) 0))))))))

(defn ^:private apply-state
  [cache-args switch-state dispatch]
  (fn [type args]
    (cache-args type args)
    (switch-state type)
    (dispatch type)))

(defn ^:private call-state
  [apply-fn]
  (fn [type]
    (fn []
      (apply-fn type arguments))))

(defn ^:private notify
  [cache-args dispatch]
  (fn []
    (cache-args :notify arguments)
    (dispatch :notify)))

(defn ^object deferred
  "Create a new deferred object"
  []
  (let [buf (new-buf)
        pool (new-pool)
        state (new-state)
        pusher (pusher pool)
        cache-args (cache-args buf)
        switch-state (switch-state state)
        dispatch (dispatch state pool buf)
        apply (apply-state cache-args switch-state dispatch)
        call-state (call-state apply)]
    (def ctx 
      { :resolve (chain ctx 
          (call-state :resolve))
        :reject (chain ctx 
          (call-state :reject))
        :notify (chain ctx 
          (notify cache-args dispatch))
        :promise (promise state pusher dispatch) }) ctx))

(defn ^promise resolved
  "Returns a promise with resolve status with a custom reason"
  [reason]
  (let [defer (deferred)]
    (.resolve defer reason)
    (.-promise defer)))

(defn ^promise rejected
  "Returns a promise with reject status with a custom reason"
  [reason]
  (let [defer (deferred)]
    (.reject defer reason)
    (.-promise defer)))

(defn ^promise when
  "Wrap a value as a promise-like object"
  [value reason]
  (if (promise? value)
    value
    (resolved reason)))
