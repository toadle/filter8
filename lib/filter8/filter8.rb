module Filter8
  class Filter8
    BLACKLIST_FILTER = :blacklist

    AVAILABLE_FILTERS = [BLACKLIST_FILTER]

    FILTER_PARAMS = {
      BLACKLIST_FILTER => [:locale, :tags, :severity]
    }
    
  end
end