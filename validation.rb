module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_writer :required_validations

    def required_validations
      @required_validations ||= []
    end

    def validate(name, validation_type, parameter = nil)
      var_name = "@#{name}".to_sym
      cur_validation = { 'var' => var_name, 'type' => validation_type, 'parameter' => parameter }
      required_validations << cur_validation
    end
  end

  module InstanceMethods
    def presence_validation(var, _parameter)
      instance_variable = instance_variable_get(var)
      if instance_variable.nil? || instance_variable.empty?
        raise 'Требуется, чтобы значение атрибута было не nil и не пустой строкой, '\
              "ошибка в переменной - #{var}\n"
      end
    end

    def format_validation(var, parameter)
      instance_variable = instance_variable_get(var)
      raise "Неверный формат у #{var}" if instance_variable !~ parameter
    end

    def check_type_validation(var, parameter)
      instance_variable = instance_variable_get(var)
      raise 'Значение атрибута не соответствует заданному классу' unless instance_variable.instance_of?(parameter)
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    def validate!
      self.class.required_validations.each do |value|
        send("#{value['type']}_validation".to_sym, value['var'], value['parameter'])
      end
    end

    def method_missing(name); end
  end
end
