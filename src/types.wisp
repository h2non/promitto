(ns promitto.lib.types)

(defn ^array new-buf [] {})

(def ^array states
  [:resolve :reject :notify])

(defn ^object new-state []
  { :pending true
    :resolve false
    :reject false })

(defn ^object new-pool []
  { :reject []
    :resolve []
    :finally []
    :notify [] })