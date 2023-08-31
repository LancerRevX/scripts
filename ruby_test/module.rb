module My_Module
  My_Const = 31

  def My_Module.my_method(a, b)
    a + b
  end

  class Another_Class
  end
end

class My_Class
  Const = 7

  def initialize()
    @var = 5
    @@var = 6
  end

  def var()
    @var
  end

  private
  Priv_Const = 8

  def priv_method()
    9
  end
end
