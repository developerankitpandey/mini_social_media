class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # def self.ransackable_attributes(auth_object = nil)
  #   ["blob_id", "created_at", "id", "name", "record_id", "record_type"]
  # end
end
