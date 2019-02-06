module Acсessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      attribute_name = "@#{name}".to_sym
      attribute_history_name = "@#{name}_history".to_sym

      define_method(name) { instance_variable_get(attribute_name) }
      define_method("#{name}_history") { instance_variable_get(attribute_history_name) }

      define_method("#{name}=".to_sym) do |value|
        old_value = instance_variable_get(attribute_name)
        instance_variable_set(attribute_name, value)

        attribute_history = instance_variable_get(attribute_history_name)
        if attribute_history.nil?
          instance_variable_set(attribute_history_name, [])
        else
          instance_variable_get(attribute_history_name) << old_value
        end
      end
    end
  end

  def strong_attr_accessor(name, type)
    attribute_name = "@#{name}".to_sym

    define_method(name) { instance_variable_get(attribute_name) }
    define_method("#{name}=".to_sym) do |value|
      raise TypeError.new("Не совпадает тип значения") unless value.is_a?(type)
      instance_variable_set(attribute_name, value)
    end
  end
end
