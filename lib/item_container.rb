module ItemContainer
  module ClassMethods
    def class_info
      "Class: #{self.name}, Version: 1.0"
    end

    def object_count
      @object_count ||= 0
    end

    def increment_object_count
      @object_count ||= 0
      @object_count += 1
    end
  end

  module InstanceMethods
    def add_item(item)
      @items << item
      self.class.increment_object_count
    end

    def remove_item(item)
      @items.delete(item)
    end

    def delete_items
      @items.clear
    end

    def show_all_items
      @items.each { |item| puts item }
    end

    def method_missing(method_name, *args)
      if method_name == :show_all_items
        show_all_items
      else
        super
      end
    end

  end

  def self.included(class_instance)
    class_instance.extend(ClassMethods)
    class_instance.include(InstanceMethods)
  end
end
