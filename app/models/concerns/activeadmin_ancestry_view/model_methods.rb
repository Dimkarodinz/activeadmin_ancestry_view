module Concerns
  module ActiveadminAncestryView::ModelMethods
    extend ActiveSupport::Concern

    included do
      # Return relation with same order as passed to method.
      # For expamle, .order_collection([2,1,3]) will return
      # relation with ids [2,1,3] against standart [1,2,3] order
      def self.ordered_collection(ids)
        order_clause = "CASE id "
        ids.each_with_index do |id, index|
          order_clause << sanitize_sql_array(["WHEN ? THEN ? ", id, index])
        end
        order_clause << sanitize_sql_array(["ELSE ? END", ids.length])

        where(id: ids).order(order_clause)
      end

      # like #ancestry but with self.id
      def full_ancestry
        return id.to_s unless ancestry
        path_ids.join('/')
      end
    end
  end
end
