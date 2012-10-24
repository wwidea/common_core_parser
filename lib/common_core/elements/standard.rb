module CommonCore
  class Standard < CommonCore::Element

    def errors
      errors = []
      errors << 'Refid is blank' if ref_id.blank?
      errors << 'PRI is blank' if parent_ref_id.blank?
      errors << 'Code is blank' if code.blank?
      errors << 'Statement is blank' if statement.blank?
      errors << 'invalid grades' unless valid_grades?
      return errors
    end

    def error_message
      errors.join(',')
    end
  end
end
