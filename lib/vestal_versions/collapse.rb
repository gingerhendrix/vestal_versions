module VestalVersions
  # Adds the ability to collapse multiple versions into a single version
  module Collapse
    def self.included(base) # :nodoc:
      base.class_eval do
        include InstanceMethods
      end
    end

    # Adds the instance methods required to collapse sequential versions
    module InstanceMethods
      # 
      #
      # 
      def collapse_versions(from, to)
        changes = changes_between(from,to)
        reset_to!(to)
        changes.reverse_changes.each do |attribute, change|
          write_attribute(attribute, change.last)
        end
      end
    end
  end
end
