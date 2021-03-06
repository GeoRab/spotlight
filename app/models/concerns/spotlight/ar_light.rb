module Spotlight
  module ArLight
    extend ActiveSupport::Concern
    include ActiveRecord::ModelSchema
    include ActiveRecord::Inheritance
    include ActiveRecord::Associations
    include ActiveRecord::Reflection
    include ActiveModel::Dirty
    included do
      def self.base_class
        self
      end
    end
    def initialize (source_doc={}, solr_response=nil)
      @association_cache = {}
      super
    end

    # Returns true if +comparison_object+ is the same exact object, or +comparison_object+
    # is of the same type and +self+ has an ID and it is equal to +comparison_object.id+.
    #
    # Note that new records are different from any other record by definition, unless the
    # other record is the receiver itself. Besides, if you fetch existing records with
    # +select+ and leave the ID out, you're on your own, this predicate will return false.
    #
    # Note also that destroying a record preserves its ID in the model instance, so deleted
    # models are still comparable.
    def ==(comparison_object)
      super ||
        comparison_object.instance_of?(self.class) &&
        id &&
        comparison_object.id == id
    end
      
    module ClassMethods
      def generated_feature_methods
        @generated_feature_methods ||= begin
          mod = const_set(:GeneratedFeatureMethods, Module.new)
          include mod
          mod
        end
      end

      def before_destroy *args
      end

      def pluralize_table_names
        true
      end

      def add_autosave_association_callbacks arg
      end

    end
  end
end
