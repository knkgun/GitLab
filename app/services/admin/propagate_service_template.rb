# frozen_string_literal: true

module Admin
  class PropagateServiceTemplate
    BATCH_SIZE = 100

    delegate :data_fields_present?, to: :template

    def self.propagate(template)
      new(template).propagate
    end

    def initialize(template)
      @template = template
    end

    def propagate
      return unless template.active?

      propagate_projects_with_template
    end

    private

    attr_reader :template

    def propagate_projects_with_template
      loop do
        batch_ids = Project.uncached { Project.ids_without_integration(template, BATCH_SIZE) }

        bulk_create_from_template(batch_ids) unless batch_ids.empty?

        break if batch_ids.size < BATCH_SIZE
      end
    end

    def bulk_create_from_template(batch_ids)
      service_list = ServiceList.new(batch_ids, service_hash).to_array

      Project.transaction do
        results = bulk_insert(*service_list)

        if data_fields_present?
          data_list = DataList.new(results, data_fields_hash, template.data_fields.class).to_array

          bulk_insert(*data_list)
        end

        run_callbacks(batch_ids)
      end
    end

    def bulk_insert(klass, columns, values_array)
      items_to_insert = values_array.map { |array| Hash[columns.zip(array)] }

      klass.insert_all(items_to_insert, returning: [:id])
    end

    def service_hash
      @service_hash ||= template.to_service_hash
    end

    def data_fields_hash
      @data_fields_hash ||= template.to_data_fields_hash
    end

    # rubocop: disable CodeReuse/ActiveRecord
    def run_callbacks(batch_ids)
      if template.issue_tracker?
        Project.where(id: batch_ids).update_all(has_external_issue_tracker: true)
      end

      if active_external_wiki?
        Project.where(id: batch_ids).update_all(has_external_wiki: true)
      end
    end
    # rubocop: enable CodeReuse/ActiveRecord

    def active_external_wiki?
      template.type == 'ExternalWikiService'
    end
  end
end
