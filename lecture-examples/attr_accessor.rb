class Foo

  def my_attr_accessor(var)
    var = var.to_s
    newmeth = %Q{
        def #{var}
          @#{var}
        end
        def #{var}=(newval)
          @#{var} = newval
        end
}
    self.class_eval newmeth
  end

end

