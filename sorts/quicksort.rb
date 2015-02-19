def log(msg)
  #puts msg
end

module Quicksort

  def self.sort(list)
    pivot = list.pop # destructive...
    if pivot
      log "pivot: #{pivot}"
      smaller, bigger = self.partition(list, pivot)
      log "\tsmaller: #{smaller}"
      log "\tbigger: #{bigger}"
      [*sort(smaller), pivot, *sort(bigger)]
    else
      []
    end
  end

  def self.partition(list, pivot)
    log "\t\tpartitioning..."
    smaller, bigger = [], []
    list.each do |element|
      log "\t\t\t...#{element}"
      if element <= pivot
        smaller.push element
      else
        bigger.push element
      end
    end
    [ smaller, bigger ]
  end

end
