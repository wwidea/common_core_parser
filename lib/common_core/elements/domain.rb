module CommonCore
  class Domain < CommonCore::Element

    def errors
      errors = []
      errors << 'Refid is blank' if ref_id.blank?
      errors << 'Code is blank' if code.blank?
      errors << 'Statement is blank' if statement.blank?
      errors << "invalid grades: #{grades}" unless valid_grades?
      return errors
    end
  end
end
