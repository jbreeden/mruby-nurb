module Nurb
  # Timer Types
  # -----------
  
  class Immediate
    include Handle
    
    def initialize(&block)
      raise ArgumentError.new("Block required") unless block_given?
      @handle = UV::UvIdleT.new
      UV.uv_idle_init(Nurb.main_loop, @handle)
      UV.uv_idle_start(@handle) do
        self.close
        block[]
      end
    end
  end
  
  class Timeout
    include Handle

    def initialize(delay, &block)
      raise ArgumentError.new("Block required") unless block_given?
      @handle = UV::UvTimerT.new
      UV.uv_timer_init(Nurb.main_loop, @handle)
      UV.uv_timer_start(@handle, delay, 1) do
        self.close
        block[]
      end
    end
  end
  
  class Interval
    include Handle

    def initialize(interval, &block)
      raise ArgumentError.new("Block required") unless block_given?
      @handle = UV::UvTimerT.new
      UV.uv_timer_init(Nurb.main_loop, @handle)
      UV.uv_timer_start(@handle, interval, interval) do
        block[]
      end
    end
  end
  
  # Public API
  # ----------
  
  def self.set_timeout(delay, &block)
    Timeout.new(delay, &block)
  end
  
  def self.set_interval(interval, &block)
    Interval.new(interval, &block)
  end
  
  def self.set_immediate(&block)
    Immediate.new(&block)
  end
  class << self
    alias next_tick set_immediate
  end
  
  def self.clear_timeout(timeout)
    timeout.close
  end
  class << self
    alias clear_interval clear_timeout
  end
end
