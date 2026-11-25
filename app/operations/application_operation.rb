class ApplicationOperation
  Result = Struct.new(:success, :data, :error, :status, keyword_init: true) do
    def success?
      success
    end

    def failure?
      !success
    end
  end

  def self.call(...)
    new(...).call
  end

  private

  def success(data = nil)
    Result.new(success: true, data: data, error: nil)
  end

  def failure(error = nil, data = nil)
    Result.new(success: false, data: data, error: error)
  end
end
